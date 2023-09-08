# This script has the ability to add "Today", "Tomorrow", and "Day after tomorrow", as parents to all the colleges
# identical to the runner on azure 7/10/23

from playwright.sync_api import sync_playwright, ViewportSize
import re
import unicodedata
from bs4 import BeautifulSoup
from copy import deepcopy
import datetime
import data_base_write
import pytz

def menu_scrape():
    url = 'https://nutrition.sa.ucsc.edu/'
    halls_html = ['text=College Nine/John R. Lewis Dining Hall', 'text=Cowell/Stevenson Dining Hall', 'text=Crown/Merrill Dining Hall', 'text=Porter/Kresge Dining Hall']
    dates = ["Today", "Tomorrow", "Day after tomorrow"]
    halls_name = ['Nine', 'Cowell', 'Merrill', 'Porter']
    meals = ["Breakfast", "Lunch", "Dinner", "Late Night"]
    food_cat = {"*Hot Bars*": [], "*Soups*": [], "*Entrees*": [], "*Grill*": [], "*Pizza*": [], "*Clean Plate*": [], "*Bakery*": [], "*Open Bars*": [], "*DH Baked*": [], "*Plant Based Station*": [], "*Miscellaneous*": [], "*Brunch*": []}
    # food_cat_new = {"Hot Bars": [], "Soups": [], "Entrees": [], "Grill": [], "Pizza": [], "Clean Plate": [], "Bakery": [], "Open Bars": [], "DH Baked": [], "Plant Based Station": [], "Miscellaneous": [], "Brunch": []}
    # Create nested dictionary
    meal_times = {}
    summary_times = {}
    for i in meals:
        meal_times.update({i: deepcopy(food_cat)})
        summary_times.update({i: []})

    meal_dates = {}
    summary_halls = {}
    for i in halls_name:
        meal_dates.update({i: deepcopy(meal_times)})
        summary_halls.update({i: deepcopy(summary_times)})

    hall_menus = {}
    summary = {}
    for i in dates:
        hall_menus.update({i: deepcopy(meal_dates)})

    summary.update({'Summary': deepcopy(summary_halls)})
    hall_menus.update(summary)

    # Go through every dining hall college and update hall_menus dictionary
    for j in range(len(halls_name)):
        index = 0                                                       # reset index
        for date in dates:                                              # loop through dates wanted
            with sync_playwright() as p:
                for attempt in range(5):
                    try:
                        browser = p.chromium.launch()
                        page = browser.new_page()
                        # page.set_viewport_size(ViewportSize(width = 1080*2, height=1920*2))
                        # page.goto(url)
                        response_code = page.goto(url)
                        if response_code.status != 200:
                            continue
                        page.locator(halls_html[j]).click()                     # select hall
                        page.wait_for_load_state("networkidle")
                        date_option = page.get_by_role("combobox")              # find date options
                        
                        # find initial index of date options
                        if index == 0:
                            options = date_option.locator("option").all_inner_texts()
                            for item in options:
                                # temp = str(datetime.date.today().strftime('%e'))
                                # if str(datetime.date.today().strftime('%e')) in item:
                                if str(datetime.datetime.now(pytz.timezone('US/Pacific')).date().strftime('%e')) in item:
                                    index = options.index(item)                 # find index of current day's date
                                    break

                        date_option.select_option(index=index)                  # select day
                        page.get_by_role("button", name="Go!").click()          # go to page
                        page.wait_for_load_state("networkidle")
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
                        # hall_menus[date][halls_name[j]][meal_time]['*' + meal_cat + '*'].append(i)
                    except:
                        hall_menus[date][halls_name[j]][meal_time].update({meal_cat: []})
                        hall_menus[date][halls_name[j]][meal_time][meal_cat].append(i)
                        # hall_menus[date][halls_name[j]][meal_time].update({'*' + meal_cat + '*': []})
                        # hall_menus[date][halls_name[j]][meal_time]['*' + meal_cat + '*'].append(i)

            # TODO: TEMP SOLUTION TO THE OPEN BARS PROBLEM IN APP
            for time in meals:
                if time == 'Breakfast': #keep this
                    hall_menus['Summary'][halls_name[j]][time] = hall_menus['Today'][halls_name[j]][time]['*Breakfast*'] # keep this
                    continue
                
                if len(hall_menus[date][halls_name[j]][time]['*Open Bars*']) == 0 and time != 'Breakfast':
                    if len(hall_menus[date][halls_name[j]][time]['*Entrees*']) == 0:
                        hall_menus['Summary'][halls_name[j]][time] = hall_menus['Today'][halls_name[j]][time]['*Hot Bars*'] # keep this
                    else:
                        hall_menus['Summary'][halls_name[j]][time] = hall_menus['Today'][halls_name[j]][time]['*Entrees*'] # keep this
                else:
                    hall_menus['Summary'][halls_name[j]][time] = hall_menus['Today'][halls_name[j]][time]['*Open Bars*'] # keep this
    
    # Add today's meals
    for hall in halls_name:
        hall_menus[hall] = hall_menus['Today'][hall]

    return hall_menus


# main
hall_menus = menu_scrape()
hall_menus.update(hall_menus)

data_base_write.UpdateDatabase(hall_menus)