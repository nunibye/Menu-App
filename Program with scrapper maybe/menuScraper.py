"""
Created 2/24/2022
@author: Ralph Miller
         Nils Brown
"""
import sys
import re
import unicodedata
from bs4 import BeautifulSoup
from selenium import webdriver
from dbsetup import createMenuDB, addMenuItem, findMenuItem

def webScrape(college):

    # Convert var college to link string
    college = college.lower()
    if college == "college910":
        linkclick = "College Nine/John R. Lewis Dining Hall"
    elif college == "cowellstevenson":
        linkclick = "Cowell/Stevenson Dining Hall"
    elif college == "crownmerrill":
        linkclick = "Crown/Merrill Dining Hall"
    elif college == "porterkresge":
        linkclick = "Porter/Kresge Dining Hall"
    else:
        print("failed")

    print("Scraping " + college +"...") # Debug statement


    # Uses headless browser to grab HTML of specific DH menu #

    # Runs headless browser without chrome popping up
    options = webdriver.ChromeOptions()
    options.add_argument('headless')
    options.add_argument('window-size=1920x1080')
    options.add_argument("disable-gpu")
    driver = webdriver.Chrome(chrome_options=options)

    driver.get('https://nutrition.sa.ucsc.edu/')
    driver.find_element_by_link_text(linkclick).click()
    pageSource = driver.page_source
    soup = BeautifulSoup(pageSource, 'html.parser')
    driver.close()

    # Parses HTML with bs4 and find all menu items #
    menuTable = soup.find('table',  {'bordercolor': '#CCC'})    # Finds meal table
    meal = menuTable.findAll("tr")                              # Finds each seperate meal table (Bfast, Lunch, ect)

    for meal in menuTable:                                      # For each item in the meal table, strip empty text
        text = meal.text.strip()                                # and save the menu item
        meal.string = re.sub(r"[\n][\W]+[^\w]", "\n", text)
    #print(meal.text)                                           # print out menu items

    # split by newline to get each line
    #remove \xa0 from string
    cleaned = unicodedata.normalize("NFKD", meal.text)
    arr = cleaned.split("\n")
    # parse the list line by line and add to database
    mealtime = ""
    for i in arr:
        # move past "Nutrition Calculator" stuff and headers
        if i == "Nutrition Calculator" or "--" in i:
            continue

        # get the meal time (bfast, lunch, etc)
        # these are the headers, so they can be excluded from database addition
        # they will only change when a new header is reached
        if i == "Breakfast":
            mealtime = "Breakfast"
            continue
        if i == "Lunch":
            mealtime = "Lunch"
            continue
        if i == "Dinner":
            mealtime = "Dinner"
            continue
        if i == "Late Night":
            mealtime = "Late Night"
            continue

        #  if at this point, add to the database
        foodname = i[:-1].lower()
        addMenuItem(college, foodname, mealtime)
