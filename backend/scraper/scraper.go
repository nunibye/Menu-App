package scraper

import (
	"bytes"
	"context"
	"crypto/tls"
	"log"
	"net/http"
	"strings"
	"time"

	firebase "firebase.google.com/go"
	"firebase.google.com/go/db"
	"github.com/PuerkitoBio/goquery"
	"github.com/gocolly/colly/v2"
)

var url = "https://nutrition.sa.ucsc.edu/"
var diningHallNames = map[string]string{
	"College Nine/John R. Lewis Dining Hall": "Nine",
	"Cowell/Stevenson Dining Hall":           "Cowell",
	"Crown/Merrill Dining Hall":              "Merrill",
	"Porter/Kresge Dining Hall":              "Porter",
	"Rachel Carson/Oakes Dining Hall":        "Oaks",
}
var mealCats = []string{
	"*Hot Bars*",
	"*Soups*",
	"*Entrees*",
	"*Grill*",
	"*Pizza*",
	"*Clean Plate*",
	"*Bakery*",
	"*Open Bars*",
	"*DH Baked*",
	"*Plant Based Station*",
	"*Miscellaneous*",
	"*Brunch*",
	"*Breakfast*",
}

var menu = make(map[string]interface{})

type PubSubMessage struct {
	Data []byte `json:"data"`
}

func ScraperRun(ctx context.Context, m PubSubMessage) error {
	config := &firebase.Config{
		DatabaseURL: "https://ucsc-menu-app-default-rtdb.firebaseio.com/",
	}
	app, err := firebase.NewApp(context.Background(), config)
	if err != nil {
		log.Fatalf("error initializing app: %v\n", err)
	}

	db, err := app.Database(context.Background())
	if err != nil {
		log.Fatalln("Error initializing database client:", err)
	}

	scrape()
	makeSummary()
	err = UpdateDatabase(db, menu)
	if err != nil {
		return err
	}

	return nil
}

func scrape() {
	a := colly.NewCollector()

	t := &http.Transport{
		TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
	}
	a.WithTransport(t)

	// visits links with dining hall
	a.OnHTML("a[href]", func(e *colly.HTMLElement) {
		dhLink := url + e.Attr("href")
		if strings.Contains(dhLink, "+Dining+Hall") {
			b := a.Clone()

			// visits links for today, tomorrow, day after
			b.OnHTML("option", func(f *colly.HTMLElement) {
				today := time.Now().Format("Monday, January 2")
				tomorrow := time.Now().AddDate(0, 0, 1).Format("Monday, January 2")
				dayAfter := time.Now().AddDate(0, 0, 2).Format("Monday, January 2")

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
							dayData, ok := menu[day].(map[string]map[string]map[string][]string)
							if !ok {
								dayData = make(map[string]map[string]map[string][]string)
								menu[day] = dayData
							}
							if dayData[diningHall] == nil {
								dayData[diningHall] = make(map[string]map[string][]string)
							}
							if dayData[diningHall][mealTime] == nil {
								dayData[diningHall][mealTime] = make(map[string][]string)
							}

							// writes data from table to map
							d.OnResponse(func(g *colly.Response) {
								reader := bytes.NewReader(g.Body)
								doc, _ := goquery.NewDocumentFromReader(reader)
								var currentCategory string

								// gets all objects from table in the food name or category classes
								doc.Find("table[bordercolor=\"#C0C0C0\"] div.longmenucoldispname, div.longmenucolmenucat").Each(func(i int, s *goquery.Selection) {
									if s.HasClass("longmenucolmenucat") { //category
										currentCategory = strings.Replace(s.Text(), "-- ", "*", -1)
										currentCategory = strings.Replace(currentCategory, " --", "*", -1)
										// Check if the current category is in the mealCats slice
										for _, cat := range mealCats {
											if currentCategory == cat {
												dayData[diningHall][mealTime][currentCategory] = []string{}
												break
											}
										}
									} else { //food item
										// Check if the current category is in the map before appending the food item
										if _, ok := dayData[diningHall][mealTime][currentCategory]; ok {
											dayData[diningHall][mealTime][currentCategory] = append(dayData[diningHall][mealTime][currentCategory], s.Text())
										}
									}
								})
							})
							d.Visit(nutritionLink)
						}
					})
					c.Visit(dateLink)
				}
			})
			b.Visit(dhLink)
		}
	})
	a.Visit(url)
}

func makeSummary() {
	// Check if "Summary" key exists in data map, if not, create it
	summaryData, ok := menu["Summary"].(map[string]map[string][]string)
	if !ok {
		summaryData = make(map[string]map[string][]string)
		menu["Summary"] = summaryData
	}

	// Get the data for "Today"
	dayData, _ := menu["Today"].(map[string]map[string]map[string][]string)

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

			// Try to get data from "*Open Bars*", then "*Entrees*", and then "*Hot Bars*"
			if len(mealTimeData["*Open Bars*"]) > 0 {
				summaryData[diningHall][mealTime] = append(summaryData[diningHall][mealTime], mealTimeData["*Open Bars*"]...)
			} else if len(mealTimeData["*Entrees*"]) > 0 {
				summaryData[diningHall][mealTime] = append(summaryData[diningHall][mealTime], mealTimeData["*Entrees*"]...)
			} else {
				summaryData[diningHall][mealTime] = append(summaryData[diningHall][mealTime], mealTimeData["*Hot Bars*"]...)
			}
		}
	}
}

func DeleteReference(client *db.Client, ref_str string) {
	ref := client.NewRef(ref_str)
	if err := ref.Delete(context.Background()); err != nil {
		log.Fatalln("Error deleting reference:", err)
	}
}

func UpdateDatabase(client *db.Client, hall_menus map[string]interface{}) error {
	references := []string{"/Merrill/", "/Oakes/", "/Cowell/", "/Nine/", "/Porter/", "/Today/", "/Tomorrow/", "/Day after tomorrow/", "/Summary/"}
	for _, ref := range references {
		DeleteReference(client, ref)
	}

	ref := client.NewRef("/")
	err := ref.Update(context.Background(), hall_menus)
	if err != nil {
		log.Fatalln("Error updating database:", err)
		return err
	}

	return nil
}
