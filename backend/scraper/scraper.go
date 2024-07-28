package main

import (
	"context"
	"crypto/tls"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"os"
	"strings"
	"time"

	firebase "firebase.google.com/go"
	"firebase.google.com/go/db"
	"github.com/gocolly/colly/v2"
)

var url = "https://nutrition.sa.ucsc.edu/"

var diningHallNames = map[string]string{
	"College Nine/John R. Lewis Dining Hall": "Nine",
	"Cowell/Stevenson Dining Hall":           "Cowell",
	"Crown/Merrill Dining Hall":              "Merrill",
	"Porter/Kresge Dining Hall":              "Porter",
	"Rachel Carson/Oakes Dining Hall":        "Oakes",
}

var excludeCategories = []string{
	"*Cereal*",
	"*All Day*",
	"*Condiments*",
	"*ACI CONDIMENTS*",
	"*Breakfast Bar*",
	"*ACI BRK BAR*",
	"*Bread and Bagels*",
	"*ACI BREAD $ BAGELS*",
	"*Beverages*",
	"*ACI BEVERAGES*",
	"*Salad Bar*",
	"*ACI SALAD BAR*",
	"*Deli Bar*",
	"*ACI DELI BAR*",
}

type NutritionalInfo struct {
	ServingSize  string
	Calories     string
	TotalFat     string
	SaturatedFat string
	TransFat     string
	Cholesterol  string
	Sodium       string
	TotalCarb    string
	DietaryFiber string
	Sugars       string
	Protein      string
	Ingredients  string
	Allergens    string
}

type FoodItem struct {
	Name            string
	NutritionalInfo NutritionalInfo
}

var menu = make(map[string]interface{})

// FIXME:
// var mutex sync.Mutex

type PubSubMessage struct {
	Data []byte `json:"data"`
}

func main() {
	// config := &firebase.Config{
	// 	DatabaseURL: "https://ucsc-menu-app-default-rtdb.firebaseio.com/",
	// }
	// app, err := firebase.NewApp(context.Background(), config)
	// if err != nil {
	// 	fmt.Printf("error initializing app: %v", err)
	// }
	// db, err := app.Database(context.Background())
	// if err != nil {
	// 	fmt.Printf("error initializing database client: %v", err)
	// }
	menu = make(map[string]interface{}) // clear menu map

	start := time.Now()

	err := scrape()
	if err != nil {
		fmt.Printf("error in scrape function: %v\n", err)
	}

	duration := time.Since(start)
	fmt.Printf("Scraping completed in %v\n", duration)

	// err = makeSummary()
	// if err != nil {
	// 	fmt.Printf("error in makeSummary function: %v", err)
	// }

	// Create a file
	file, err := os.Create("menu.json")
	if err != nil {
		fmt.Printf("error creating file: %v", err)
	}
	defer file.Close()

	// Write the menu to the file in a readable format
	menuJson, err := json.MarshalIndent(menu, "", "  ")
	if err != nil {
		fmt.Printf("error marshalling menu: %v", err)
	}
	_, err = file.Write(menuJson)
	if err != nil {
		fmt.Printf("error writing to file: %v", err)
	}

	// err = UpdateDatabase(db, menu)
	// if err != nil {
	// 	fmt.Printf("error updating database: %v", err)
	// }
}

func ScraperRun(ctx context.Context, m PubSubMessage) error {
	config := &firebase.Config{
		DatabaseURL: "https://ucsc-menu-app-default-rtdb.firebaseio.com/",
	}
	app, err := firebase.NewApp(context.Background(), config)
	if err != nil {
		return fmt.Errorf("error initializing app: %v", err)
	}

	db, err := app.Database(context.Background())
	if err != nil {
		return fmt.Errorf("error initializing database client: %v", err)
	}

	menu = make(map[string]interface{}) // clear menu map

	maxRetries := 3
	retryDelay := 5 * time.Second

	for retry := 0; retry < maxRetries; retry++ {
		err = scrape()
		if err == nil {
			break
		}
		time.Sleep(retryDelay)
	}
	if err != nil {
		return fmt.Errorf("error in scrape function: %v", err)
	}

	for retry := 0; retry < maxRetries; retry++ {
		err = makeSummary()
		if err == nil {
			break
		}
		time.Sleep(retryDelay)
	}
	if err != nil {
		return fmt.Errorf("error in makeSummary function: %v", err)
	}

	for retry := 0; retry < maxRetries; retry++ {
		err = UpdateDatabase(db, menu)
		if err == nil {
			break
		}
		time.Sleep(retryDelay)
	}
	if err != nil {
		return fmt.Errorf("error updating database: %v", err)
	}

	return nil
}

func scrape() error {
	a := colly.NewCollector()

	t := &http.Transport{
		TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
	}
	a.WithTransport(t)

	// FIXME:
	// sem := make(chan bool, 10)

	// visits links with dining hall
	a.OnHTML("a[href]", func(e *colly.HTMLElement) {
		dhLink := url + e.Attr("href")

		if strings.Contains(dhLink, "Dining+Hall") {
			b := a.Clone()

			// visits links for today, tomorrow, day after
			b.OnHTML("option", func(f *colly.HTMLElement) {
				location, _ := time.LoadLocation("America/Los_Angeles")

				today := time.Now().In(location).Format("Monday, January 2")
				tomorrow := time.Now().In(location).AddDate(0, 0, 1).Format("Monday, January 2")
				dayAfter := time.Now().In(location).AddDate(0, 0, 2).Format("Monday, January 2")

				// set day label for dictionary
				var day string
				if strings.Contains(f.Text, today) {
					day = "Today"
				} else if strings.Contains(f.Text, tomorrow) {
					day = "Tomorrow"
				} else if strings.Contains(f.Text, dayAfter) {
					day = "Day after tomorrow"
				}

				if day != "" {
					dateLink := url + f.Attr("value")
					c := b.Clone()

					// visits nutrition calculator link
					c.OnHTML("a[href]", func(f *colly.HTMLElement) {
						nutritionLink := url + f.Attr("href")
						if strings.Contains(nutritionLink, "mealName=") {
							d := c.Clone()

							// set dining hall names from variable
							diningHall := diningHallNames[e.Text]

							// set meal time name
							var mealTime string
							if strings.Contains(f.Attr("href"), "Breakfast") {
								mealTime = "Breakfast"
							} else if strings.Contains(f.Attr("href"), "Lunch") {
								mealTime = "Lunch"
							} else if strings.Contains(f.Attr("href"), "Dinner") {
								mealTime = "Dinner"
							} else if strings.Contains(f.Attr("href"), "Late+Night") {
								mealTime = "Late Night"
							}

							// initialize map
							dayData, ok := menu[day].(map[string]map[string]map[string][]FoodItem)
							if !ok {
								dayData = make(map[string]map[string]map[string][]FoodItem)
								menu[day] = dayData
							}
							if dayData[diningHall] == nil {
								dayData[diningHall] = make(map[string]map[string][]FoodItem)
							}
							if dayData[diningHall][mealTime] == nil {
								dayData[diningHall][mealTime] = make(map[string][]FoodItem)
							}

							// writes data from table to map
							d.OnHTML("table[bordercolor=\"#C0C0C0\"]", func(h *colly.HTMLElement) {
								var currentCategory string

								h.ForEach("div.longmenucoldispname, div.longmenucolmenucat", func(_ int, s *colly.HTMLElement) {
									class := s.Attr("class")
									if strings.Contains(class, "longmenucolmenucat") { //category

										currentCategory = strings.Replace(s.Text, "-- ", "*", -1)
										currentCategory = strings.Replace(currentCategory, " --", "*", -1)

										// Check if the current category is in the exclusion list
										excluded := false
										for _, cat := range excludeCategories {
											if currentCategory == cat {
												excluded = true
												break
											}
										}

										// If the category is not in the exclusion list, add it to the map
										if !excluded {
											// mutex.Lock()
											if _, ok := dayData[diningHall][mealTime][currentCategory]; !ok {
												dayData[diningHall][mealTime][currentCategory] = []FoodItem{}
											}
											// mutex.Unlock()
										}
									} else { //food item
										// Check if the current category is in the map before appending the food item
										if _, ok := dayData[diningHall][mealTime][currentCategory]; ok {
											foodName := s.ChildText("a")
											foodLink := url + s.ChildAttr("a", "href")

											// Create a new collector for the nutritional info page
											e := d.Clone()

											var nutritionalInfo NutritionalInfo

											e.OnHTML("body.labelbody", func(body *colly.HTMLElement) {
												var servingSizeNext bool
												// Get serving size and calories
												body.ForEach("td[rowspan='8']", func(_ int, cell *colly.HTMLElement) {
													cell.ForEach("font", func(i int, font *colly.HTMLElement) {
														text := strings.TrimSpace(font.Text)
														if servingSizeNext {
															nutritionalInfo.ServingSize = text
															servingSizeNext = false
														} else if strings.Contains(text, "Serving Size") {
															servingSizeNext = true
														} else if strings.Contains(text, "Calories") {
															calories := strings.TrimSpace(strings.TrimPrefix(text, "Calories"))
															nutritionalInfo.Calories = calories
														}
													})
												})

												// Nutrition Facts table
												body.ForEach("table[border='1'] tr", func(_ int, row *colly.HTMLElement) {
													row.ForEach("td", func(i int, cell *colly.HTMLElement) {
														label := strings.TrimSpace(cell.ChildText("font:first-child"))
														value := strings.TrimSpace(cell.ChildText("font:nth-child(2)"))

														switch {
														case strings.Contains(label, "Total Fat"):
															nutritionalInfo.TotalFat = value
														case strings.Contains(label, "Sat. Fat"):
															nutritionalInfo.SaturatedFat = value
														case strings.Contains(label, "Trans Fat"):
															nutritionalInfo.TransFat = value
														case strings.Contains(label, "Cholesterol"):
															nutritionalInfo.Cholesterol = value
														case strings.Contains(label, "Sodium"):
															nutritionalInfo.Sodium = value
														case strings.Contains(label, "Tot. Carb."):
															nutritionalInfo.TotalCarb = value
														case strings.Contains(label, "Dietary Fiber"):
															nutritionalInfo.DietaryFiber = value
														case strings.Contains(label, "Sugars"):
															nutritionalInfo.Sugars = value
														case strings.Contains(label, "Protein"):
															nutritionalInfo.Protein = value
														}
													})
												})

												// Ingredients
												nutritionalInfo.Ingredients = body.ChildText(".labelingredientsvalue")

												// Allergens
												nutritionalInfo.Allergens = body.ChildText(".labelallergensvalue")

												// Add the food item to the dayData map
												// mutex.Lock()
												dayData[diningHall][mealTime][currentCategory] = append(
													dayData[diningHall][mealTime][currentCategory],
													FoodItem{Name: foodName, NutritionalInfo: nutritionalInfo},
												)
												// mutex.Unlock()
											})
											e.Visit(foodLink)
										}
									}
								})
								// FIXME:
								// <-sem
							})
							// FIXME:
							// sem <- true
							// go d.Visit(nutritionLink)
							d.Visit(nutritionLink)
						}
					})
					c.Visit(dateLink)
				}
			})
			b.Visit(dhLink)
		}
	})
	err := a.Visit(url)
	if err != nil {
		return err
	}

	// FIXME:
	// for i := 0; i < cap(sem); i++ {
	// 	sem <- true
	// }

	return nil
}

func makeSummary() error {
	// Check if "Summary" key exists in data map, if not, create it
	summaryData, ok := menu["Summary"].(map[string]map[string][]string)
	if !ok {
		summaryData = make(map[string]map[string][]string)
		menu["Summary"] = summaryData
	}

	// Get the data for "Today"
	dayData, ok := menu["Today"].(map[string]map[string]map[string][]string)
	if !ok {
		return errors.New("no data for 'Today' in menu")
	}

	// Iterate over each dining hall
	for diningHall, diningHallData := range dayData {
		if summaryData[diningHall] == nil {
			summaryData[diningHall] = make(map[string][]string)
		}

		// Iterate over each meal time
		for mealTime, mealTimeData := range diningHallData {
			// Copy data from "Breakfast" category for breakfast
			if mealTime == "Breakfast" {
				summaryData[diningHall][mealTime] = append(summaryData[diningHall][mealTime], mealTimeData["*Breakfast*"]...)
				continue
			}

			// Handle late night at Merrill
			if diningHall == "Merrill" && mealTime == "Late Night" {
				summaryData[diningHall][mealTime] = append(summaryData[diningHall][mealTime], mealTimeData["*Banana Joes*"]...)
				continue
			}

			// Try to get data from "*Open Bars*", then "*Hot Bars*", then "*Entrees*", then "*Unit Specialties*", then "*Grill*"
			if len(mealTimeData["*Open Bars*"]) > 0 {
				summaryData[diningHall][mealTime] = append(summaryData[diningHall][mealTime], mealTimeData["*Open Bars*"]...)
			} else if len(mealTimeData["*Hot Bars*"]) > 0 {
				summaryData[diningHall][mealTime] = append(summaryData[diningHall][mealTime], mealTimeData["*Hot Bars*"]...)
			} else if len(mealTimeData["*Entrees*"]) > 0 {
				summaryData[diningHall][mealTime] = append(summaryData[diningHall][mealTime], mealTimeData["*Entrees*"]...)
			} else if len(mealTimeData["*Unit Specialties*"]) > 0 {
				summaryData[diningHall][mealTime] = append(summaryData[diningHall][mealTime], mealTimeData["*Unit Specialties*"]...)
			} else if len(mealTimeData["*Grill*"]) > 0 {
				summaryData[diningHall][mealTime] = append(summaryData[diningHall][mealTime], mealTimeData["*Grill*"]...)
			} else {
				// If none of the above categories exist, add the first category that exists
				for _, items := range mealTimeData {
					if len(items) > 0 {
						summaryData[diningHall][mealTime] = append(summaryData[diningHall][mealTime], items...)
						break
					}
				}
			}
		}
	}

	return nil
}

func DeleteReference(client *db.Client, ref_str string) error {
	ref := client.NewRef(ref_str)
	if err := ref.Delete(context.Background()); err != nil {
		return err
	}
	return nil
}

func UpdateDatabase(client *db.Client, hall_menus map[string]interface{}) error {
	references := []string{"/Merrill/", "/Oakes/", "/Cowell/", "/Nine/", "/Porter/", "/Today/", "/Tomorrow/", "/Day after tomorrow/", "/Summary/"}
	for _, ref := range references {
		err := DeleteReference(client, ref)
		if err != nil {
			return err
		}
	}

	ref := client.NewRef("/")
	err := ref.Update(context.Background(), hall_menus)
	if err != nil {
		return err
	}

	return nil
}
