"""
Created 3/6/2022
@author: Ralph Miller
         Nils Brown

         Driver program for DiningHall 411 Demo
         
"""

# Proof of concept for the dining hall 411 text program
from dbsetup import createMenuDB, addMenuItem, findMenuItem
from menuScraper import webScrape
from setup import startupScript
import os


# On startup run webscraper and install any libraries needed

if os.path.exists("DHmenus.db"):
    os.remove("DHmenus.db")

startupScript()
college_names = ["College910", "CowellStevenson", "CrownMerrill", "PorterKresge"]
for items in college_names:
    webScrape(items)

while True:
    print()
    print("               |-----------------------------|")
    print("               | Welcome to Dining Hall 411! |")
    print("               |-----------------------------|")
    print()
    response = input("""Respond with one or both of the following options or [Q] to quit:
    -Location <RachelCarson, PorterKresge, CrownMerrill, CowellStevenson, College910>
    -Food <Name of Specific Meal>\n""")

    print() # add newline for nice-ness

    if response.upper() == "Q":
        print("Bye <3")
        break

    #storing response in lowercase, splitting at options
    response = response.lower()
    splitone = response.split("-")

    #storing location, date, food in temp variables
    location = None
    food = None

    #remove argument from input
    for i in splitone:
        if "location" in i:
            temp = i.split(" ", 1)
            location = temp[-1]
            #if there is a space in location, remove it
            if " " in location:
                location = location.replace(" ", "")
        if "food" in i:
            temp = i.split(" ", 1)
            food = temp[-1]

    #Query Database
    query = findMenuItem(location, food)

    #clean query and respond
    #if a specific food is specified print a single message with where it is
    #otherwise, loop through all the menu items for the requested date, and
    #print the meal time (lunch, dinner, etc) followed by the food name.
    if query == []:
        print("Nothing found for your request")
    if food:
        for i in query:
            print("{} is at {} for {}".format(i[1],i[0], i[2]))
    else:
        temp = query[0]
        temp = temp[1]
        print("The menu for the {} location is:".format(temp))
        for i in query:
            print("{}: {}".format(i[2], i[1]))


