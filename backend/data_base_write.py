import firebase_admin
from firebase_admin import credentials
from firebase_admin import db

# Fetch the service account key JSON file contents
cred = credentials.Certificate('secrets/ucsc-menu-app-firebase-adminsdk-v9h9m-b961fb93ce.json')

# Initialize the app with a service account, granting admin privileges
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://ucsc-menu-app-default-rtdb.firebaseio.com/'
})

# As an admin, the app has access to read and write all data, regradless of Security Rules
def UpdateDatabase(hall_menus):
    #breakfast_entrees = ['apple', 'banana', 'pie']
    ref = db.reference('/')
    #ref.set(breakfast_entrees)
    ref.delete()
    
    # value: A dictionary containing the child keys to update, and their new values.
    # dictTest = {"Cowell": {"Breakfast": {"Entrees": ["test234", "test2", "test235"]}}, "Merrill": {"Breakfast": {"Entrees": ["test6", "test5", "test6"]}}}
    ref.update(hall_menus)
    

# UpdateDatabase()