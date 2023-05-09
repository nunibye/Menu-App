# This script has the ability to add "Today", "Tomorrow", and "Day after tomorrow", as parents to all the colleges

from playwright.sync_api import sync_playwright, ViewportSize
import re
import unicodedata
from bs4 import BeautifulSoup
from copy import deepcopy
import datetime
import data_base_write

def menu_scrape():
    url = 'https://nutrition.sa.ucsc.edu/'
    halls_html = ['text=College Nine/John R. Lewis Dining Hall', 'text=Cowell/Stevenson Dining Hall', 'text=Crown/Merrill Dining Hall', 'text=Porter/Kresge Dining Hall']
    dates = ["Today", "Tomorrow", "Day after tommorw"]
    halls_name = ['Nine', 'Cowell', 'Merrill', 'Porter']
    meals = ["Breakfast", "Lunch", "Dinner", "Late Night"]
    food_cat = {"*Soups*": [], "*Entrees*": [], "*Grill*": [], "*Pizza*": [], "*Clean Plate*": [], "*Bakery*": [], "*Open Bars*": [], "*DH Baked*": [], "*Plant Based Station*": [], "*Miscellaneous*": [], "*Brunch*": []}

    # Create nested dictionary
    meal_times = {}
    for i in meals:
        meal_times.update({i: deepcopy(food_cat)})

    meal_dates = {}
    for i in halls_name:
        meal_dates.update({i: deepcopy(meal_times)})

    hall_menus = {}
    for i in dates:
        hall_menus.update({i: deepcopy(meal_dates)})

    # Go through every dining hall college and update hall_menus dictionary
    for j in range(len(halls_name)):
        index = 0                                                       # reset index
        for date in dates:                                              # loop through dates wanted
            with sync_playwright() as p:
                for attempt in range(5):
                    try:
                        browser = p.chromium.launch()
                        page = browser.new_page()
                        page.set_viewport_size(ViewportSize(width = 1080*2, height=1920*2))
                        page.goto(url)
                        page.locator(halls_html[j]).click()                     # select hall
                        date_option = page.get_by_role("combobox")              # find date options
                        
                        # find initial index of date options
                        if index == 0:
                            options = date_option.locator("option").all_inner_texts()
                            for item in options:
                                # temp = str(datetime.date.today().strftime('%e'))
                                if str(datetime.date.today().strftime('%e')) in item:
                                    index = options.index(item)                 # find index of current day's date
                                    break

                        date_option.select_option(index=index)                  # select day
                        page.get_by_role("button", name="Go!").click()          # go to page
                        index += 1

                        html = page.content()
                        soup = BeautifulSoup(html, 'html.parser')
                        browser.close()
                    except:
                        continue
                    else:
                        break

            menuTable = soup.find('table',  {'bordercolor': '#CCC'})    # Finds meal table

            if menuTable == None:                                       # Error check if hall is closed
                continue

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
                if i in meal_times.keys():                              # If 'Breakfast', 'Lunch', 'Dinner', or 'Late Night'
                    meal_time = i                                       # Set current meal time
                    continue
                elif "--" in i:                                         # If at a meal category
                    meal_cat = i.strip("- ")                            # Clean string
                    meal_cat = '*' + meal_cat + '*'
                    continue
                else:                                                   # Append meals to dictionary
                    # add to the dictionary if the meal category is not in the list
                    try:
                        hall_menus[date][halls_name[j]][meal_time][meal_cat].append(i)
                    except:
                        hall_menus[date][halls_name[j]][meal_time].update({meal_cat: []})
                        hall_menus[date][halls_name[j]][meal_time][meal_cat].append(i)

    return hall_menus

def menu_scrape_today():
    url = 'https://nutrition.sa.ucsc.edu/'
    halls_html = ['text=College Nine/John R. Lewis Dining Hall', 'text=Cowell/Stevenson Dining Hall', 'text=Crown/Merrill Dining Hall', 'text=Porter/Kresge Dining Hall']

    halls_name = ['Nine', 'Cowell', 'Merrill', 'Porter']
    meals = ["Breakfast", "Lunch", "Dinner", "Late Night"]
    food_cat = {"*Soups*": [], "*Entrees*": [], "*Grill*": [], "*Pizza*": [], "*Clean Plate*": [], "*Bakery*": [], "*Open Bars*": [], "*DH Baked*": [], "*Plant Based Station*": [], "*Miscellaneous*": [], "*Brunch*": []}

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
            # If the browser does not launch, try again
            for attempt in range(5):
                try:
                    browser = p.chromium.launch()  #headless=False
                    page = browser.new_page()
                    page.set_viewport_size(ViewportSize(width = 1080*2, height=1920*2))
                    page.goto(url)
                    page.locator(halls_html[j]).click()
                    html = page.content()
                    soup = BeautifulSoup(html, 'html.parser')
                    browser.close()
                except:
                    continue
                else:
                     break

        menuTable = soup.find('table',  {'bordercolor': '#CCC'})    # Finds meal table

        if menuTable == None:                                       # Error check if hall is closed
                        continue

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
            if i in meal_times.keys():                              # If 'Breakfast', 'Lunch', 'Dinner', or 'Late Night'
                meal_time = i                                       # Set current meal time
                continue
            elif "--" in i:                                         # If at a meal category
                meal_cat = i.strip("- ")                            # Clean string
                meal_cat = '*' + meal_cat + '*'     
                continue
            else:                                                   # Append meals to dictionary
                # add to the dictionary if the meal category is not in the list
                try:
                    hall_menus[halls_name[j]][meal_time][meal_cat].append(i)
                except:
                    hall_menus[halls_name[j]][meal_time].update({meal_cat: []})
                    hall_menus[halls_name[j]][meal_time][meal_cat].append(i)
    return hall_menus


# main
hall_menus = menu_scrape()
hall_menus_today = menu_scrape_today()
hall_menus.update(hall_menus_today)
data_base_write.UpdateDatabase(hall_menus)