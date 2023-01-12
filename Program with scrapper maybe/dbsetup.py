import sqlite3

def createMenuDB():
    connection = sqlite3.connect('DHmenus.db')
    cursor = connection.cursor()
    cursor.execute('''CREATE TABLE IF NOT EXISTS DiningHallMenus
                  (DiningHall TEXT, MealName TEXT, MealTime TEXT)''')
    connection.commit()
    connection.close()

def addMenuItem(DiningHall, MealName, MealTime):
    #try to connect to database
    #if it doesnt connect create the database

    createMenuDB()
    connection = sqlite3.connect('DHmenus.db')

    #Generate SQL Query and insert Data
    sql = ''' INSERT INTO DiningHallMenus(DiningHall, MealName, MealTime)
                  VALUES(?,?,?) '''
    params = (DiningHall,MealName,MealTime)
    cur = connection.cursor()
    cur.execute(sql, params)
    connection.commit()
    connection.close()

def findMenuItem(DiningHall, MealName):
    #generates SQL for Date, Dining Hall Location, and optional specific meal
    connection = sqlite3.connect('DHmenus.db')
    if MealName:
        if not DiningHall:
            sql = '''SELECT * from DiningHallMenus 
                    WHERE MealName = ?'''
            params = (MealName,)
        else:
            sql = '''SELECT * from DiningHallMenus 
                WHERE DiningHall = ? AND MealName = ?'''
            params = (DiningHall, MealName)
    else:
        sql = '''SELECT * from DiningHallMenus 
            WHERE DiningHall = ?'''
        params = (DiningHall,)
    cur = connection.cursor()
    cur.execute(sql, params)
    return(cur.fetchall())
