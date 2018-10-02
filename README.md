# API Documentation

## users#create (register)

POST https://fierce-forest-56311.herokuapp.com/users

api_token not required

required keys:
* name
* email, must be unique
* password, minimum length: 5

optional keys:
* phone_number



## users#edit (update)

POST https://fierce-forest-56311.herokuapp.com/users/:id

api_token required

required keys:
* password, minimum length: 5

optional keys:
* name
* email, must be unique
* phone_number


## users#index (all users)

GET https://fierce-forest-56311.herokuapp.com/users

<!-- Will eventually need manager api_token -->


## users#destroy (delete users)

<!-- Will eventually need manager api_token -->

DELETE https://fierce-forest-56311.herokuapp.com/users/:id



## users#login (login)

POST https://fierce-forest-56311.herokuapp.com/logins

api_token not required

required keys:
* email
* password


## calendars#index

GET https://fierce-forest-56311.herokuapp.com/calendars

api_token required


## calendars#create

POST	https://fierce-forest-56311.herokuapp.com/calendars

api_token required

required keys:
* name (string) must exist
* time_zone (string) must be valid time zone string (see documentation/valid_time_zones.txt)

optional keys:
* employee_hour_threshold_daily (float)
* employee_hour_threshold_weekly (float)
* daylight_savings (boolean)


## calendars#show

GET	https://fierce-forest-56311.herokuapp.com/calendars/:id

api_token required (must be owner, manager, or employee of calendar)


## calendars#update
PATCH	https://fierce-forest-56311.herokuapp.com/calendars/:id

api_token required (must be owner or manager of calendar)

optional keys:
* name (string) must exist
* time_zone (string) must be valid time zone string (see documentation/valid_time_zones.txt)
* employee_hour_threshold_daily (float)
* employee_hour_threshold_weekly (float)
* daylight_savings (boolean)


## calendars#destroy
DELETE	https://fierce-forest-56311.herokuapp.com/calendars/:id

api_token required (must be owner of calendar)
