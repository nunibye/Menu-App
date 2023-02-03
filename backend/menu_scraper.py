from playwright.sync_api import sync_playwright, ViewportSize
import time
import re
import unicodedata
from bs4 import BeautifulSoup
import data_base_write
from copy import deepcopy
url = 'https://nutrition.sa.ucsc.edu/'
halls_html = ['text=College Nine/John R. Lewis Dining Hall', 'text=Cowell/Stevenson Dining Hall', 'text=Crown/Merrill Dining Hall', 'text=Porter/Kresge Dining Hall']

halls_name = ['Nine', 'Cowell', 'Merrill', 'Porter']
meals = ["Breakfast", "Lunch", "Dinner", "Late Night"]
food_cat = {"*Breakfast*": [], "*Soups*": [], "*Entrees*": [], "*Grill*": [], "*Pizza*": [], "*Clean Plate*": [], "*Bakery*": [], "*Open Bars*": [], "*DH Baked*": [], "*Plant Based Station*": [], "*Miscellaneous*": []}

# Create nested dictionary
meal_times = {}
for i in meals:
    meal_times.update({i: deepcopy(food_cat)})

hall_menus = {}
for i in halls_name:
    hall_menus.update({i: deepcopy(meal_times)}) 

# Go through every dining hall college and update hall_menus dictionary
for j in range(len(halls_name)):

    with sync_playwright() as p:
        browser = p.chromium.launch()  #headless=False
        page = browser.new_page()
        page.set_viewport_size(ViewportSize(width = 1080*2, height=1920*2))
        page.goto(url)
        page.locator(halls_html[j]).click()
        
        html = page.content()
        soup = BeautifulSoup(html, 'html.parser')
        browser.close()

    menuTable = soup.find('table',  {'bordercolor': '#CCC'})    # Finds meal table
    list_of_food = []

    for meal in menuTable:                                      # For each item in the meal table, strip empty text
        text = meal.text.strip()                                # and save the menu item
        meal.string = re.sub(r"[\n][\W]+[^\w]", "\n", text)
        
    # Format List
    cleaned = unicodedata.normalize("NFKD", meal.text)          # Cleans html
    meals_list = []
    meals_list = cleaned.split("\n")                            # Splits data into a list
    for i in range(len(meals_list)):
        meals_list[i] = meals_list[i].strip()

    # Remove "nutrition calculator" from meals list
    n_calc_caount = meals_list.count('Nutrition Calculator')
    for i in range(n_calc_caount):
        meals_list.remove('Nutrition Calculator')

    # Updates hall_menu dictionary
    for i in meals_list:
        if i in meal_times.keys():                              # If Breakfast, Lunch, Dinner, or Late Night
            meal_time = i                                       # Set current meal time
            continue
        elif "--" in i:                                         # If at a meal category
            meal_cat = i.strip("- ")                            # Clean string
            meal_cat = '*' + meal_cat + '*'     
            continue
        else:                                                   # Append meals to dictionary
            hall_menus[halls_name[j]][meal_time][meal_cat].append(i)
        
data_base_write.UpdateDatabase(hall_menus)                      # Update database





