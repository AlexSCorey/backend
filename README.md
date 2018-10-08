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



## users#update

PATCH https://fierce-forest-56311.herokuapp.com/users/:id

api_token required

required keys:
* password, minimum length: 5

optional keys:
* name
* email, must be unique
* phone_number


## users#index (all users per calendar)

GET https://fierce-forest-56311.herokuapp.com/calendars/:id/users

api_token required



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


## roles#destroy (remove user from calendar)
DELETE	https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/users/:user_id/role

api_token required (owners of calendar permitted to remove owners, managers, and employees; managers of calendar permitted to remove managers and employees only)

required keys:
* role (string) must exist, must be "owner", "manager", or "employee"


## roles#create (add additional role to user on calendar)
POST	https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/users/:user_id/role

api_token required (owners of calendar permitted to add owners, managers, and employees; managers of calendar permitted to add managers and employees only)

required keys:
* role (string) must exist, must be "owner", "manager", or "employee", cannot duplicate existing user/calendar/role combination



## shifts#index (index of shifts based on role)
GET     https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/shifts

api_token required (must be owner or manager to view all shifts, must be employee to view published shifts)

## shifts#create (add shifts to calendar)
POST    https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/shifts

api_token required (must be owner or manager to create shift)

required keys:
* start_time (must be earlier than end time)
* end_time  (must be after start time)
* calendar_id
* capacity (must be greater than 0)
* published (boolean)


## shifts#update (update shifts on calendar)
PATCH    https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/shifts/:id

api_token required (must be owner or manager to create shift)

required keys:
* id
* calendar_id

optional keys:
* start_time
* end_time
* capacity
* published


## shifts#destroy (update shifts on calendar)
DELETE    https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/shifts/:id

api_token required (must be owner or manager to create shift)

required keys:
* id
* calendar_id

## usershifts#create (add employee to a shift)
POST     https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/shifts/:id/usershifts

api_token required (must be owner or manager to create employee shift)

required keys:
* calendar_id
* user_id
* shift_id

## usershifts#destroy (delete employee from a shift)
DELETE     https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/shifts/:id/usershifts/:id

api_token required (must be owner or manager to delete employee shift)

required keys:
* user_id
* shift_id
* calendar_id


## invitations#create (invite to calendar via email)
POST	https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/invitation	

api_token required (owners of calendar permitted to add owners, managers, and employees; managers of calendar permitted to add managers and employees only)

required keys:
* email (string) must exist
* role (string) must exist, must be "owner", "manager", or "employee", cannot duplicate existing user/calendar/role combination


## invitations#complete (complete new user registration process)
POST	https://fierce-forest-56311.herokuapp.com/invitations/complete

api_token required - use the invitation token from welcome email, not a user api_token

required keys:
* name
* password, minimum length: 5

optional keys:
* phone_number


## notes#index
GET	https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/notes?start_date=:start_date&end_date=:end_date

api_token required - must be user of calendar, managers and owners will get all notes, employees will get only their notes

query string required: the arguments in the URL are strictly required for this index to limit notes to a specific date range.  Replace :start_date and :end_date with the appropriate dates and times, e.g.: ?start_date=2018-06-30&end_date=2018-07-06


## notes#create
POST	https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/notes

api_token required - must be user associated with calendar

required keys:
* text (string)
* date (whole date only, e.g. 2018-10-06)