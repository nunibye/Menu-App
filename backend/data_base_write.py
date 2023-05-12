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
    '''
    Takes a nested dictionary of Dining Hall, Meal Time, Meal Category, and Meals.
    Updates firebase json database.
    '''
    ref = db.reference('/')
    ref.delete()
    
    for attempt in range(5):
        try:
            ref.update(hall_menus)
        except:
            continue