from playwright.sync_api import sync_playwright, ViewportSize
import time
import re
from bs4 import BeautifulSoup
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
meal = menuTable.findAll("tr")                              # Finds each seperate meal table (Bfast, Lunch, ect)

for meal in menuTable:                                      # For each item in the meal table, strip empty text
    text = meal.text.strip()                                # and save the menu item
    meal.string = re.sub(r"[\n][\W]+[^\w]", "\n", text)
print(meal.text)