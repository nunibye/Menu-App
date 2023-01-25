from playwright.sync_api import sync_playwright, ViewportSize
import time
import re
import unicodedata
from bs4 import BeautifulSoup
import data_base_write
url = 'https://nutrition.sa.ucsc.edu/'
with sync_playwright() as p:
    browser = p.chromium.launch()  #headless=False
    page = browser.new_page()
    page.set_viewport_size(ViewportSize(width = 1080*2, height=1920*2))
    page.goto(url)
    page.locator('text=Cowell/Stevenson Dining Hall').click()
    
    html = page.content()
    #print(html)
    soup = BeautifulSoup(html, 'html.parser')
    browser.close()


menuTable = soup.find('table',  {'bordercolor': '#CCC'})    # Finds meal table
#meal = menuTable.findAll("tr")                              # Finds each seperate meal table (Bfast, Lunch, ect)
list_of_food = []
for meal in menuTable:                                      # For each item in the meal table, strip empty text
    text = meal.text.strip()                                # and save the menu item
    meal.string = re.sub(r"[\n][\W]+[^\w]", "\n", text)
    
cleaned = unicodedata.normalize("NFKD", meal.text)
meals_list = cleaned.split("\n")
for i in range(len(meals_list)):
    meals_list[i] = meals_list[i].strip()
    #print(meals_list[i])
print('\n')
n_calc_caount = meals_list.count('Nutrition Calculator')
for i in range(n_calc_caount):
    meals_list.remove('Nutrition Calculator')

# Create nested dictionary
meal_times = {"Breakfast": {"Breakfast": [], "Entrees": [], "Clean Plate": [], "Bakery": []},
              "Lunch": {"Soups": [], "Entrees": [], "Grill": [], "Pizza": [], "Clean Plate": [], "Bakery": [], "Open Bars": [], "DH Baked": []},
              "Dinner": {"Soups": [], "Entrees": [], "Grill": [], "Pizza": [], "Clean Plate": [], "Bakery": [], "Open Bars": [], "DH Baked": []},
              "Late Night": {"Soups": [], "Entrees": [], "Grill": [], "Pizza": [], "Clean Plate": [], "Bakery": [], "Open Bars": [], "DH Baked": []}}
hall_menus = {"Cowell": meal_times, "Merrill": meal_times} # ETC, ETC
for i in meals_list:
    if i in meal_times.keys():
        meal_time = i
        continue
    if "--" in i:
        meal_cat = i.strip("- ")
        continue
    else:
        meal_times[meal_time][meal_cat].append(i)

print(meal_times)
        
data_base_write.UpdateDatabase(meal_times)





