from playwright.sync_api import sync_playwright, ViewportSize
import time
import re
import unicodedata
from bs4 import BeautifulSoup
import data_base_write
url = 'https://nutrition.sa.ucsc.edu/'
halls_html = ['text=College Nine/John R. Lewis Dining Hall', 'text=Cowell/Stevenson Dining Hall', 'text=Crown/Merrill Dining Hall', 'text=Porter/Kresge Dining Hall']
halls_name = ['Nine', 'Cowell', 'Merrill', 'Porter']
# meal_times = {"Breakfast": {"Breakfast": [], "Entrees": [], "Clean Plate": [], "Bakery": []},
#             "Lunch": {"Soups": [], "Entrees": [], "Grill": [], "Pizza": [], "Clean Plate": [], "Bakery": [], "Open Bars": [], "DH Baked": [], "Plant Based Station": []},
#             "Dinner": {"Soups": [], "Entrees": [], "Grill": [], "Pizza": [], "Clean Plate": [], "Bakery": [], "Open Bars": [], "DH Baked": [], "Plant Based Station": []},
#             "Late Night": {"Soups": [], "Entrees": [], "Grill": [], "Pizza": [], "Clean Plate": [], "Bakery": [], "Open Bars": [], "DH Baked": [], "Plant Based Station": []}}

# Create nested dictionary
meal_times = {"Breakfast": {"*Breakfast*": [], "*Entrees*": [], "*Clean Plate*": [], "*Bakery*": []},
            "Lunch": {"*Soups*": [], "*Entrees*": [], "*Grill*": [], "*Pizza*": [], "*Clean Plate*": [], "*Bakery*": [], "*Open Bars*": [], "*DH Baked*": [], "*Plant Based Station*": []},
            "Dinner": {"*Soups*": [], "*Entrees*": [], "*Grill*": [], "*Pizza*": [], "*Clean Plate*": [], "*Bakery*": [], "*Open Bars*": [], "*DH Baked*": [], "*Plant Based Station*": []},
            "Late Night": {"*Soups*": [], "*Entrees*": [], "*Grill*": [], "*Pizza*": [], "*Clean Plate*": [], "*Bakery*": [], "*Open Bars*": [], "*DH Baked*": [], "*Plant Based Station*": []}}
#hall_menus = {"Cowell": meal_times, "Merrill": meal_times, "Nine": meal_times, "Porter": meal_times}
hall_menus = {}
for i in halls_name:
    hall_menus.update({i: meal_times})
#print(hall_menus)


for j in range(len(halls_name)):

    with sync_playwright() as p:
        browser = p.chromium.launch()  #headless=False
        page = browser.new_page()
        page.set_viewport_size(ViewportSize(width = 1080*2, height=1920*2))
        page.goto(url)
        page.locator(halls_html[j]).click()                     # changes dining hall html page
        
        html = page.content()
        soup = BeautifulSoup(html, 'html.parser')
        browser.close()

    menuTable = soup.find('table',  {'bordercolor': '#CCC'})    # Finds meal table
    # meal = menuTable.findAll("tr")                            # Finds each seperate meal table (Bfast, Lunch, ect)
    list_of_food = []
    print(type(menuTable))
    for meal in menuTable:                                      # For each item in the meal table, strip empty text
        text = meal.text.strip()                                # and save the menu item
        meal.string = re.sub(r"[\n][\W]+[^\w]", "\n", text)
        
    # Format List
    cleaned = unicodedata.normalize("NFKD", meal.text)
    meals_list = []
    meals_list = cleaned.split("\n")
    for i in range(len(meals_list)):
        meals_list[i] = meals_list[i].strip()

    n_calc_caount = meals_list.count('Nutrition Calculator')
    for i in range(n_calc_caount):
        meals_list.remove('Nutrition Calculator')
    #print(meals_list)
    for i in meals_list:
        if i in meal_times.keys():
            meal_time = i
            continue
        elif "--" in i:
            meal_cat = i.strip("- ")
            meal_cat = '*' + meal_cat + '*'
            continue
        else:
            hall_menus[halls_name[j]][meal_time][meal_cat].append(i)

#print(hall_menus)
        
data_base_write.UpdateDatabase(hall_menus)





