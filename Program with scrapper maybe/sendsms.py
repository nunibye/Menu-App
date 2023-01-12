pip install twilio

# Import our twilio environment
from twilio.rest import Client

# create our client
client = Client("AC88238d61ea83edd122eebfbd7a78d69f", "AUTH TOKEN HERE")

def sendintro():
    #Send the Text Options
    client.messages.create(to="+18057222771",
                           from_="+15076974468",
                           body="Welcome to Dining Hall 411! Options are as follows:")
    #messages for options
    client.messages.create(to="+18057222771",
                           from_="+15076974468",
                           body="-Location <Dining Hall> -Meal <Name of Specific Meal> -Date <Date>")

def sendselected(dh_name, meal, date):
    pass
