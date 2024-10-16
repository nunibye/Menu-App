package scraper_v2

import (
	"context"
	"crypto/tls"
	"errors"
	"fmt"
	"net/http"
	"path"
	"strings"
	"sync"
	"time"

	firebase "firebase.google.com/go"
	"firebase.google.com/go/db"
	"github.com/gocolly/colly/v2"
)

// declarations
var url = "https://nutrition.sa.ucsc.edu/"

var diningHallNames = map[string]string{
	"John R. Lewis & College Nine Dining Hall": "Nine",
	"Cowell & Stevenson Dining Hall":           "Cowell",
	"Crown & Merrill Dining Hall":              "Merrill",
	"Porter & Kresge Dining Hall":              "Porter",
	"Rachel Carson & Oakes Dining Hall":        "Oakes",
}

var excludeCategories = []string{
	"Cereal",
	"All Day",
	"Condiments",
	"ACI CONDIMENTS",
	"Breakfast Bar",
	"ACI BRK BAR",
	"Bread and Bagels",
	"Bread & Bagels",
	"ACI BREAD $ BAGELS",
	"Beverages",
	"ACI BEVERAGES",
	"Salad Bar",
	"ACI SALAD BAR",
	"Deli Bar",
	"ACI DELI BAR",
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
	Tags         []string
}

type FoodItem struct {
	Name            string
	NutritionalInfo NutritionalInfo
}

type Category struct {
	Name      string
	FoodItems []FoodItem
}

type PubSubMessage struct {
	Data []byte `json:"data"`
}

// global menu map
var menu = make(map[string]interface{})

// main function
// func main() {
// 	config := &firebase.Config{
// 		DatabaseURL: "https://ucsc-menu-app-default-rtdb.firebaseio.com/",
// 	}
// 	app, err := firebase.NewApp(context.Background(), config)
// 	if err != nil {
// 		fmt.Printf("error initializing app: %v", err)
// 	}
// 	db, err := app.Database(context.Background())
// 	if err != nil {
// 		fmt.Printf("error initializing database client: %v", err)
// 	}

// 	menu = make(map[string]interface{}) // clear menu map

// 	start := time.Now()
// 	err = scrape()
// 	if err != nil {
// 		fmt.Printf("error in scrape function: %v\n", err)
// 	}
// 	duration := time.Since(start)
// 	fmt.Printf("Scraping completed in %v\n", duration)

// 	err = reorderCategories()
// 	if err != nil {
// 		fmt.Printf("error in reorderCategories function: %v", err)
// 	}

// 	err = makeSummary()
// 	if err != nil {
// 		fmt.Printf("error in makeSummary function: %v", err)
// 	}

// 	// // Create a file
// 	// file, err := os.Create("menu.json")
// 	// if err != nil {
// 	// 	fmt.Printf("error creating file: %v", err)
// 	// }
// 	// defer file.Close()

// 	// // Write the menu to the file in a readable format
// 	// menuJson, err := json.MarshalIndent(menu, "", "  ")
// 	// if err != nil {
// 	// 	fmt.Printf("error marshalling menu: %v", err)
// 	// }
// 	// _, err = file.Write(menuJson)
// 	// if err != nil {
// 	// 	fmt.Printf("error writing to file: %v", err)
// 	// }

// 	err = UpdateDatabase(db, menu)
// 	if err != nil {
// 		fmt.Printf("error updating database: %v", err)
// 	}
// }

// google cloud function
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

	maxRetries := 2
	retryDelay := 1 * time.Second

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

	err = reorderCategories()
	if err != nil {
		return fmt.Errorf("error in reorderCategories function: %v", err)
	}

	err = makeSummary()
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

// scrape functions
func scrape() error {
	var mu sync.Mutex
	a := colly.NewCollector(
		colly.Async(true),
		colly.MaxDepth(4),
	)

	// Set up error handling
	a.OnError(func(r *colly.Response, err error) {
		fmt.Printf("Request URL: %s failed with response: %v\nError: %v\n", r.Request.URL, r, err)
	})

	// Configure transport for TLS
	a.WithTransport(&http.Transport{
		TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
	})

	// Handler for dining hall links
	a.OnHTML("a[href]", func(e *colly.HTMLElement) {
		dhLink := url + e.Attr("href")
		if strings.Contains(dhLink, "Dining+Hall") {
			diningHall := diningHallNames[e.Text]
			err := processHall(a.Clone(), diningHall, dhLink, &mu)
			if err != nil {
				fmt.Printf("Error processing dining hall %s: %v\n", e.Text, err)
			}
		}
	})

	// Start the scraping process
	err := a.Visit(url)
	if err != nil {
		return err
	}

	// Wait for all asynchronous operations to complete
	a.Wait()

	return nil
}

func processHall(b *colly.Collector, diningHall string, dhLink string, mu *sync.Mutex) error {
	// Handler for date options
	b.OnHTML("option", func(f *colly.HTMLElement) {
		day := getDayLabel(f.Text)
		if day != "" {
			dateLink := url + f.Attr("value")
			err := processDate(b.Clone(), diningHall, day, dateLink, mu)
			if err != nil {
				fmt.Printf("Error processing date %s: %v\n", f.Text, err)
			}
		}
	})

	err := b.Visit(dhLink)
	if err != nil {
		return err
	}

	b.Wait()

	return nil
}

func processDate(c *colly.Collector, diningHall string, day, dateLink string, mu *sync.Mutex) error {
	// Handler for meal links
	c.OnHTML("a[href]", func(g *colly.HTMLElement) {
		nutritionLink := url + g.Attr("href")
		if strings.Contains(nutritionLink, "mealName=") {
			mealTime := getMealTime(g.Attr("href"))
			err := processMeal(c.Clone(), nutritionLink, day, diningHall, mealTime, mu)
			if err != nil {
				fmt.Printf("Error processing meal %s at %s: %v\n", mealTime, diningHall, err)
			}
		}
	})

	err := c.Visit(dateLink)
	if err != nil {
		return err
	}

	c.Wait()

	return nil
}

func processMeal(d *colly.Collector, nutritionLink, day, diningHall, mealTime string, mu *sync.Mutex) error {
	// Initialize the menu structure if necessary
	mu.Lock()
	initializeMenuStructure(day, diningHall, mealTime)
	mu.Unlock()

	// Handler for the meal table
	d.OnHTML("table[bordercolor=\"#C0C0C0\"]", func(h *colly.HTMLElement) {
		var currentCategory string

		h.ForEach("div.longmenucoldispname, div.longmenucolmenucat", func(_ int, s *colly.HTMLElement) {
			if strings.Contains(s.Attr("class"), "longmenucolmenucat") {
				currentCategory = processCategory(s.Text)
				if !isExcludedCategory(currentCategory) {
					mu.Lock()
					addCategory(day, diningHall, mealTime, currentCategory)
					mu.Unlock()
				}
			} else if currentCategory != "" && !isExcludedCategory(currentCategory) {
				foodName := s.ChildText("a")
				foodLink := url + s.ChildAttr("a", "href")
				processFoodItem(d.Clone(), foodName, foodLink, day, diningHall, mealTime, currentCategory, mu)
			}
		})
	})

	err := d.Visit(nutritionLink)
	if err != nil {
		return err
	}

	d.Wait()

	return nil
}

func processFoodItem(e *colly.Collector, foodName, foodLink, day, diningHall, mealTime, category string, mu *sync.Mutex) {
	e.AllowURLRevisit = true
	var nutritionalInfo NutritionalInfo

	e.OnHTML("body.labelbody", func(body *colly.HTMLElement) {
		// Process serving size and calories
		processServingAndCalories(body, &nutritionalInfo)

		// Process nutrition facts
		processNutritionFacts(body, &nutritionalInfo)

		// Process ingredients and allergens
		nutritionalInfo.Ingredients = body.ChildText(".labelingredientsvalue")
		nutritionalInfo.Allergens = body.ChildText(".labelallergensvalue")

		// Process tags
		processTags(body, &nutritionalInfo)

		// Add the food item to the menu
		mu.Lock()
		addFoodItem(day, diningHall, mealTime, category, FoodItem{Name: foodName, NutritionalInfo: nutritionalInfo})
		mu.Unlock()
	})

	err := e.Visit(foodLink)
	if err != nil {
		fmt.Printf("Error processing food item %s: %v\n", foodName, err)
	}
	e.Wait()
}

// helper functions for scrape
func getDayLabel(dateText string) string {
	location, _ := time.LoadLocation("America/Los_Angeles")
	today := time.Now().In(location).Format("Monday, January 2")
	tomorrow := time.Now().In(location).AddDate(0, 0, 1).Format("Monday, January 2")
	dayAfter := time.Now().In(location).AddDate(0, 0, 2).Format("Monday, January 2")

	switch {
	case strings.Contains(dateText, today):
		return "Today"
	case strings.Contains(dateText, tomorrow):
		return "Tomorrow"
	case strings.Contains(dateText, dayAfter):
		return "Day after tomorrow"
	default:
		return ""
	}
}

func getMealTime(href string) string {
	switch {
	case strings.Contains(href, "Breakfast"):
		return "Breakfast"
	case strings.Contains(href, "Lunch"):
		return "Lunch"
	case strings.Contains(href, "Dinner"):
		return "Dinner"
	case strings.Contains(href, "Late+Night"):
		return "Late Night"
	default:
		return ""
	}
}

func processCategory(categoryText string) string {
	category := strings.Replace(categoryText, "-- ", "", -1)
	return strings.Replace(category, " --", "", -1)
}

func isExcludedCategory(category string) bool {
	for _, excludedCat := range excludeCategories {
		if category == excludedCat {
			return true
		}
	}
	return false
}

func initializeMenuStructure(day, diningHall, mealTime string) {
	if menu[day] == nil {
		menu[day] = make(map[string]map[string][]Category)
	}
	dayData := menu[day].(map[string]map[string][]Category)
	if dayData[diningHall] == nil {
		dayData[diningHall] = make(map[string][]Category)
	}
	if dayData[diningHall][mealTime] == nil {
		dayData[diningHall][mealTime] = []Category{}
	}
}

func addCategory(day, diningHall, mealTime, category string) {
	dayData := menu[day].(map[string]map[string][]Category)
	newCategory := Category{
		Name:      category,
		FoodItems: []FoodItem{},
	}
	dayData[diningHall][mealTime] = append(dayData[diningHall][mealTime], newCategory)
}

func addFoodItem(day, diningHall, mealTime, category string, foodItem FoodItem) {
	dayData := menu[day].(map[string]map[string][]Category)
	for i, cat := range dayData[diningHall][mealTime] {
		if cat.Name == category {
			dayData[diningHall][mealTime][i].FoodItems = append(dayData[diningHall][mealTime][i].FoodItems, foodItem)
			break
		}
	}
}

func processServingAndCalories(body *colly.HTMLElement, nutritionalInfo *NutritionalInfo) {
	var servingSizeNext bool
	body.ForEach("td[rowspan='8']", func(_ int, cell *colly.HTMLElement) {
		cell.ForEach("font", func(i int, font *colly.HTMLElement) {
			text := strings.TrimSpace(font.Text)
			if servingSizeNext {
				nutritionalInfo.ServingSize = text
				servingSizeNext = false
			} else if strings.Contains(text, "Serving Size") {
				servingSizeNext = true
			} else if strings.Contains(text, "Calories") {
				nutritionalInfo.Calories = strings.TrimSpace(strings.TrimPrefix(text, "Calories"))
			}
		})
	})
}

func processNutritionFacts(body *colly.HTMLElement, nutritionalInfo *NutritionalInfo) {
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
}

func processTags(body *colly.HTMLElement, nutritionalInfo *NutritionalInfo) {
	body.ForEach(".labelwebcodesvalue img", func(_ int, img *colly.HTMLElement) {
		fileName := path.Base(img.Attr("src"))
		nutritionalInfo.Tags = append(nutritionalInfo.Tags, fileName)
	})
}

// adjust menu map functions
func reorderCategories() error {
	// reorderCategories reorders the categories in the global menu map
	for day, dayData := range menu {
		// Ensure dayData is of the correct type
		diningHalls, ok := dayData.(map[string]map[string][]Category)
		if !ok {
			return errors.New("dayData not of the correct type")
		}

		// Iterate over each dining hall
		for diningHall, diningHallData := range diningHalls {
			// Iterate over each mealtime
			for mealTime, categories := range diningHallData {
				// Apply reordering logic to the categories
				reorderedCategories := reorder(categories, mealTime, diningHall)
				// Update the global menu map with reordered categories
				menu[day].(map[string]map[string][]Category)[diningHall][mealTime] = reorderedCategories
			}
		}
	}
	return nil
}

func reorder(categories []Category, mealTime, diningHall string) []Category {
	priorityOrder := map[string][]string{
		"Breakfast":   {"Breakfast"},
		"Banana Joes": {"Banana Joes"},
		"Default":     {"Open Bars", "Hot Bars", "Entrees", "Unit Specialties", "Grill"},
	}

	var orderedCategories []Category
	priority := priorityOrder["Default"]

	if mealTime == "Breakfast" {
		priority = priorityOrder["Breakfast"]
	} else if mealTime == "Late Night" && diningHall == "Merrill" {
		priority = priorityOrder["Banana Joes"]
	}

	// Add categories based on priority
	for _, p := range priority {
		for _, c := range categories {
			if c.Name == p {
				orderedCategories = append(orderedCategories, c)
			}
		}
	}

	// Add remaining categories
	for _, c := range categories {
		found := false
		for _, p := range priority {
			if c.Name == p {
				found = true
				break
			}
		}
		if !found {
			orderedCategories = append(orderedCategories, c)
		}
	}

	return orderedCategories
}

func makeSummary() error {
	// Check if "Summary" key exists in data map, if not, create it
	summaryData, ok := menu["Summary"].(map[string]map[string]Category)
	if !ok {
		summaryData = make(map[string]map[string]Category)
		menu["Summary"] = summaryData
	}

	// Get the data for "Today"
	dayData, ok := menu["Today"].(map[string]map[string][]Category)
	if !ok {
		return errors.New("no data for 'Today' in menu")
	}

	// Iterate over each dining hall
	for diningHall, diningHallData := range dayData {
		if summaryData[diningHall] == nil {
			summaryData[diningHall] = make(map[string]Category)
		}

		// Iterate over each meal time
		for mealTime, categories := range diningHallData {
			// Assuming you want to take the first category from the list for the summary
			if len(categories) > 0 {
				summaryData[diningHall][mealTime] = categories[0]
			}
		}
	}

	return nil
}

// Database functions
func DeleteReference(client *db.Client, ref_str string) error {
	ref := client.NewRef(ref_str)
	if err := ref.Delete(context.Background()); err != nil {
		return err
	}
	return nil
}

func UpdateDatabase(client *db.Client, hall_menus map[string]interface{}) error {
	references := []string{"/menuv2/"}
	for _, ref := range references {
		err := DeleteReference(client, ref)
		if err != nil {
			return err
		}
	}

	ref := client.NewRef("/menuv2/")
	err := ref.Update(context.Background(), hall_menus)
	if err != nil {
		return err
	}

	return nil
}
