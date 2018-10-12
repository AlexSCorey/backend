# API Documentation


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


## calendars#summary
GET	https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/summary?start_date=:start_date&end_date=:end_date

api_token required - must be user of calendar

query string required: the arguments in the URL are strictly required for this summary to limit for a specific date range.  Replace :start_date and :end_date with the appropriate dates and times, e.g.: ?start_date=2018-06-30&end_date=2018-07-06


## calendars#alerts_daily
GET	https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/alerts_daily?date=:date


api_token required - must be manager or owner of calendar

query string required: the date argument in the URL is strictly required.  Replace :date with the appropriate date, e.g.: ?start_date=2018-06-30




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


## password#forgot
POST	https://fierce-forest-56311.herokuapp.com/passwords/forgot (request new pw)

required keys
* email

## password#reset
POST	https://fierce-forest-56311.herokuapp.com/passwords/reset (reset new pw)

required keys
* email
* new password
* reset_password_token (only valid 2 hours, destroys after 1 use)



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


##shifts#copy
POST    https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/copy?start_date=:start_date&end_date=:end_date&target_date=:target_date

api_token required (must be owner or manager of calendar)

query string required: the arguments in the URL are strictly required to limit for a specific date range.  Replace :start_date, :end_date, and :target_date with the appropriate dates and times, e.g.: ?start_date=2018-06-30&end_date=2018-07-06&target_date=2018-07-13.  Target date is the beginning of the new schedule.



## shifts#index (index of shifts based on role)
GET     https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/shifts?start_date=:start_date&end_date=:end_date

api_token required (must be user of calendar)

query string required: the arguments in the URL are strictly required to limit for a specific date range.  Replace :start_date and :end_date with the appropriate dates and times, e.g.: ?start_date=2018-06-30&end_date=2018-07-06

## shifts#create (add shifts to calendar)
POST    https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/shifts

api_token required (must be owner or manager to create shift)

required keys:
* start_time (must be earlier than end time)
* end_time  (must be after start time)
* calendar_id
* capacity (must be greater than 0)


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



##shifts#myschedule (View of all of a users published schedules for all calendars limit of 100)
GET    https://fierce-forest-56311.herokuapp.com/myschedule


required keys:
* api_token



## shifts#copy (copy calendar from previous)
POST    https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/copy

required keys:
* calendar_id



## swaps#create (request that other users take over a shift)
POST	https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/shifts/:shift_id/swaps

api_token required - must be user associated with shift

no keys required


## swaps#index (view list of shifts swap requests)
GET	https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/swaps

api_token required - must be user of calendar

no keys required


## swaps#update (accept shift swap request pending manager approval)
PATCH	https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/swaps/:id

api_token required - must be user of calendar


## swaps#complete
POST	https://fierce-forest-56311.herokuapp.com/swaps/complete

api_token required - use the invitation token from swap decision email, not a user api_token

required keys:
* decision (string) must be either "approve" or "deny"


## swap#show
GET	https://fierce-forest-56311.herokuapp.com/swap

api_token required - use the invitation token from swap decision email, not a user api_token

no keys required


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

optional keys:
* name
* email, must be unique
* phone_number
* password, minimum length: 5


## users#index (all users per calendar)

GET https://fierce-forest-56311.herokuapp.com/calendars/:id/users

api_token required



## users#login (login)

POST https://fierce-forest-56311.herokuapp.com/logins

api_token not required

required keys:
* email
* password



## users#shift_users_index
GET	https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/shifts/:shift_id/users

api_token required - must be user of calendar

no keys required



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


## availability_processes#create (request availability)
POST	https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/availability_process

api_token required (must be owner or manager of calendar)

required keys:
* start_date
* end_date


## availability_responses#show
GET https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/availability_response

api_token required - use the response token from availability request email, not a user api_token

no keys required


## availability_responses#update (update user availability)
PATCH	https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/availability_response

api_token required - use the response token from availability request email, not a user api_token

required keys:
* responses: contains a hash with response ids for the keys and availability booleans for the values, e.g.:
```JSON
"responses":
        {"751": true,
        "752": false,
        "753": true,
        "754": false,
        "755": true,
        "756": false,
        "757": true,
        "758": false,
        "759": true,
        "760": false}
```


## availability_processes#assign_shifts (run the algorithm)
POST https://fierce-forest-56311.herokuapp.com/calendars/:calendar_id/availability_processes/:availability_process_id/assign_shifts	

api_token required (must be owner or manager of calendar)

no keys required