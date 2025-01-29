# Phoenix skill test

Ecommerce back office API backend demo, developed with Phoenix framework.

## Local development

### Dev server setup

To start your Phoenix server:

  - Make sure [Phoenix dependencies](https://hexdocs.pm/phoenix/installation.html) are installed on your machine
  - `cd server`
  - Run `mix setup` to install and setup dependencies
  - Copy `.env.example` and rename it to `.env`
  - Change env variables values - `GUARDIAN_SECRET` should be changed to a different string (you can use `mix guardian.gen.secret` to get it). The same is true for `SECRET_KEY_BASE`.
  - Source .env file with `source .env`
  - Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

### Test

  - Make sure you followed **Dev server setup** instructions
  - Run `mix test`. Remember to source `.env` file!

## Docker

  - Make sure [Docker compose](https://docs.docker.com/compose/install/) is installed on your machine
  - `cd server`
  - Set the environment variables `GUARDIAN_SECRET` and `SECRET_KEY_BASE` as explained in the previous section. You can also change the Docker compose-specific env variables (`POSTGRES_USER`, `POSTGRES_PASSWORD` and `POSTGRES_DB`)
  - `docker compose up -d`
  - `docker compose exec phoenix bash`
  - From the phoenix container shell launch these commands:
    - `mix ecto.migrate` - launches migrations to generate database tables
    - Create a user (necessary to login and call apis that require a valid JWT):
      - `iex -S mix`
      - `Server.Users.create_user(%{username: "me", password: "secret"})`

## API Docs

### Sort, filter and pagination

Sorting, filtering and pagination are available in all the *list* apis (e.g. `/api/clients`). The only exception is `api/users`, which simply lists all users without pagination.

#### Sort

Sorting works like this:

> GET `api/clients?sort=name,-email`

This will return all clients, first ordered by name (ascending) and then by email (descending).

By default, sorting is ascending for every field. To specify descending sorting for a specific table field, simply append a `-` before the field name.

#### Filter

Filtering works like this:

> GET `/api/clients?filter[name]=Gerry&filter[email]=@gmail.com`

This will return all clients that match each of the defined conditions: name has to include "Gerry" and email has to include "@gmail.com".

This filter simply looks for a substring inside the database field. It doesn't use perfect match since it is designed to make frontend table filtering work out of the box.
</br>
If we wanted, we could further refine it to allow the API user to choose which matching strategy to adopt.

#### Pagination

Pagination works like this:

> GET `/api/clients?page[limit]=2&page[offset]=4`

Instead of returning the whole clients list, this will show only two clients, while skipping the first 4 in the result set.

By default, page limit is set to 10, while page offset is 0.

#### Combining sorting, filtering and pagination

All three can be used at a time. We just have to pass multiple parameters like this:

> GET `/api/clients?filter[name]=Gerry&filter[email]=@gmail.com&sort=name,-email&page[limit]=2&page[offset]=4`

### Endpoints

APIs in the docs are written like this:

(**TOKEN_TYPE**) METHOD `api/endpoint`

If **TOKEN_TYPE** is specified, it means a JWT is needed to access the route.
</br>
Token types:
- **A**: Access token, obtained during login, user registration or token refresh.
- **R**: Reset token, obtained with the GET `/api/reset-token` API. It is required to reset a password and it is short-lived.

#### Authentication

POST `/api/register`

Creates a new user and returns user data plus new user JWT.

> Payload:  
`{
    "user": {
        "username": "me",
        "password": "secret"
    }
}`  
Response:  
`{
    "data": {
        "user": {
            "id": 1,
            "username": "me"
        },
        "token": "your_jwt"
    }
}`

POST `/api/login`

Creates a new user and returns user data plus new user JWT.

> Payload:  
`{
    "user": {
        "username": "me",
        "password": "secret"
    }
}`  
Response:  
`{
    "data": {
        "user": {
            "id": 1,
            "username": "me"
        },
        "token": "your_jwt"
    }
}`

**A** POST `/api/verify`

Verifies access token validity.

> Payload: not needed  
Response:  
`{
    "message": "valid_token"
}`  
or  
`{
    "message": "invalid_token"
}`


**A** GET `/api/reset-token`

Gets a reset token, necessary to call POST `/api/reset-password`.

> Response:  
{
    "token": "your_reset_jwt"
}

**R** POST `/api/reset-password`

Resets user password. Requires a reset token (see GET `/api/reset-token`)

> Payload:  
{"password": "secret"}  
Response:  
{
    "message": "password change successful!"
}

**A** POST `/api/refresh`

Gets a new valid access token.

> Payload: not needed  
Response:  
{
    "new_token": "your_jwt"
}

#### Clients

**A** GET `/api/clients`

Gets the list of clients. This can be sorted and filtered and it implements pagination (see above **Sort, filter and pagination** section).

> Response:  
{
    "data": [
        {
            "id": 1,
            "location": "Tokyo, Japan",
            "email": "jotarokujo@info.jp",
            "first_name": "Jotaro",
            "hobby": "Stand user",
            "last_name": "Kujo",
            "phone_number": "+813584294385"
        },
        {
            "id": 2,
            "location": "Cairo, Egypt",
            "email": "diobrando@info.jp",
            "first_name": "Dio",
            "hobby": "Stand user",
            "last_name": "Brando",
            "phone_number": "+813584294385"
        }
    ],
    "pagination": {
        "offset": null,
        "limit": null,
        "total_count": 2
    }
}

**A** GET `/api/clients/{client_id}`

Gets a specific client.

> Response:  
{
    "data": {
        "id": 1,
        "location": "Tokyo, Japan",
        "email": "jotarokujo@info.jp",
        "first_name": "Jotaro",
        "hobby": "Stand user",
        "last_name": "Kujo",
        "phone_number": "+813584294385"
    }
}

**A** POST `/api/clients/{client_id}`

Creates a client.

> Payload:  
{
    "client": {
        "location": "Tokyo, Japan",
        "email": "jotarokujo@info.jp",
        "first_name": "Jotaro",
        "hobby": "Stand user",
        "last_name": "Kujo",
        "phone_number": "+813584294385"
    }
}  
Response:  
{
    "data": {
        "id": 1,
        "location": "Tokyo, Japan",
        "email": "jotarokujo@info.jp",
        "first_name": "Jotaro",
        "hobby": "Stand user",
        "last_name": "Kujo",
        "phone_number": "+813584294385"
    }
}

**A** PUT/PATCH `/api/clients/{client_id}`

Updates a client.

> Payload:  
{
    "client": {
        "location": "Tokyo, Japan",
        "email": "jotarokujo@info.jp",
        "first_name": "Jotaro",
        "hobby": "Stand user",
        "last_name": "Kujo",
        "phone_number": "+813584294385"
    }
}  
Response:  
{
    "data": {
        "id": 1,
        "location": "Tokyo, Japan",
        "email": "jotarokujo@info.jp",
        "first_name": "Jotaro",
        "hobby": "Stand user",
        "last_name": "Kujo",
        "phone_number": "+813584294385"
    }
}

**A** DELETE `api/clients/{client_id}`

Deletes a client.

Payload: not needed  
Response: empty response with 204 status

#### Categories
**A** GET `/api/categories`

Gets the list of categories. This can be sorted and filtered and it implements pagination (see above **Sort, filter and pagination** section).

> Response:  
{
    "data": [
        {
            "id": 1,
            "name": "manga"
        }
    ],
    "pagination": {
        "offset": null,
        "limit": null,
        "total_count": 1
    }
}

**A** GET `/api/categories/{category_id}`

Gets a specific category.

> Response:  
{
    "data": {
        "id": 1,
        "name": "manga"
    }
}

**A** POST `/api/categories/{category_id}`

Creates a category.

> Payload:  
{
    "category": {
        "name": "manga",
    }
}
Response:  
{
    "data": {
        "id": 1,
        "name": "manga",
    }
}

**A** PUT/PATCH `/api/categories/{category_id}`

Updates a category.

> Payload:  
{
    "category": {
        "name": "manga",
    }
}
Response:  
{
    "data": {
        "id": 1,
        "name": "manga",
    }
}

**A** DELETE `api/categories/{category_id}`

Deletes a category.

Payload: not needed  
Response: empty response with 204 status

#### Products
**A** GET `/api/products`

Gets the list of products. This can be sorted and filtered and it implements pagination (see above **Sort, filter and pagination** section).

> Response:  
{
    "data": [
        {
            "id": 1,
            "name": "Phantom Blood vol. 1",
            "category_id": 1,
            "price": 9.99
        }
    ],
    "pagination": {
        "offset": null,
        "limit": null,
        "total_count": 1
    }
}

**A** GET `/api/products/{product_id}`

Gets a specific product.

> Response:  
{
    "data": {
        "id": 1,
        "name": "Phantom Blood vol. 1",
        "category_id": 1,
        "price": 9.99
    }
}

**A** POST `/api/products/{product_id}`

Creates a product.

> Payload:  
{
    "product": {
        "name": "Phantom Blood vol. 1",
        "price": 9.99,
        "category_id": 1
    }
}
Response:  
{
    "data": {
        "id": 1,
        "name": "Phantom Blood vol. 1",
        "category_id": 1,
        "price": 9.99
    }
}

**A** PUT/PATCH `/api/products/{product_id}`

Updates a product.

> Payload:  
{
    "product": {
        "name": "Phantom Blood vol. 1",
        "price": 9.99,
        "category_id": 1
    }
}  
Response:  
{
    "data": {
        "id": 1,
        "name": "Phantom Blood vol. 1",
        "category_id": 1,
        "price": 9.99
    }
}

**A** DELETE `api/products/{product_id}`

Deletes a product.

Payload: not needed  
Response: empty response with 204 status

#### Sold products
**A** GET `/api/sold-products`

Gets the list of sold-products. This cannot be filtered (it shouldn't be enabled for the actual ecommerce back-office application).

> Response:  
[
    {
        "id": 1,
        "selling_time": "2024-11-01T00:00:00.000000"
        "client_id": 1,
        "product_id": 1
    }
]

#### Data for charts

**A** GET `/api/sold-products/sold-products-by-category`

Gets the amount of products that have been sold by category.

> Response:
[
    {"category_name": "figures", "sold_products_count": 4},
    {"category_name": "manga", "sold_products_count": 3}
]

**A** GET `/api/sold-products/sold-products-by-month`

Gets the amount of products that have been sold by month

> Response:  
[
    {"count": 2, "date": "2024-11-01T00:00:00.000000"},
    {"count": 1, "date": "2024-12-01T00:00:00.000000"},
    {"count": 4, "date": "2025-01-01T00:00:00.000000"}
]

**A** GET `/api/sold-products/monthly-income`

Gets the total income by month.

> Response:  
[
    {"date" => "2024-11-01T00:00:00.000000", "income" => 69.98},
    {"date" => "2024-12-01T00:00:00.000000", "income" => 29.99},
    {"date" => "2025-01-01T00:00:00.000000", "income" => 54.96}
]