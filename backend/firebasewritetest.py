import firebase_admin

cred_obj = firebase_admin.credentials.Certificate('....path to file')
default_app = firebase_admin.initialize_app(cred_object, {
	'databaseURL':databaseURL
	})