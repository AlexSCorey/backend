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

api_token required





## users#login (login)

POST https://fierce-forest-56311.herokuapp.com/logins

api_token not required

required keys:
* email
* password


