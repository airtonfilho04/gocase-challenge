# Gocase - Backend Challenge

This project is a API Rest build in Ruby on Rails which the main purpose is to receive **Purchase Orders** from other sites and systems, group them on **Batches** and follow the Orders in the **production pipeline** until the dispatch. [Challenge Link](https://github.com/paulo9/gocase-internship-challenge/blob/master/README.md)

* Ruby version - 2.7.1

* Rails version - 6.0.3

The APIi is also available on heroku to occasionally facilitate testing to be performed.
Link: https://gc-challenge.herokuapp.com/ 

## Entities

The models were created with a typing that would not be used in real life. Most have the string type for brevity.

### Order            

|      Data       |  Type  |
|-----------------|--------|
|Reference        |String  |
|Purchase Channel |String  |
|Client Name      |String  |
|Address          |String  |
|Delivery Service |String  |
|Total Value      |String  |
|Line Items       |Text    |
|Status           |Integer |

### Batch

|      Data       |  Type    |
|-----------------|----------|
|Reference        |String    |
|Purchase Channel |String    |
|Order            |Reference |

## Actions

The endpoints were built to meet all the requirements described in the challenge. The architecture of requests and responses for each endpoint is described below.

### Create a new Order

#### POST /v1/orders/create

It creates a new order and set its status to "ready". It does not accept empty values.

The json object request must follow the following structure:

This action expects an json object with the following structure and non-empty values:
```yaml
{
    "order": {
        "reference": "BR102030",
        "purchase_channel": "Site BR",
        "client_name": "Rogerio Lima",
        "address": "Rua Padre Valdevino, 2475 - Aldeota, Fortaleza - CE, 60135-041",
        "delivery_service": "SEDEX",
        "total_value": "$ 123,30",
        "line_items": "[{ sku: case-my-best-friend, model: iPhone X, case type: Rose Leather },{ sku: powebank-sunshine, capacity: 10000mah },{ sku: earphone-standard, color: white }]"
    }
}
```

If success, it returns the created order and the status "201 Created".
```yaml
{
    "order": {
        "id": 21,
        "reference": "BR102030",
        "purchase_channel": "Site BR",
        "client_name": "Rogerio Lima",
        "address": "Rua Padre Valdevino, 2475 - Aldeota, Fortaleza - CE, 60135-041",
        "delivery_service": "SEDEX",
        "total_value": "$ 123,30",
        "line_items": "[{ sku: case-my-best-friend, model: iPhone X, case type: Rose Leather },{ sku: powebank-sunshine, capacity: 10000mah },{ sku: earphone-standard, color: white }]",
        "status": "ready",
        "batch_id": null,
        "created_at": "2020-06-09T20:53:54.260Z",
        "updated_at": "2020-06-09T20:53:54.260Z"
    }
}
```

If fail, it returns an error object. e.g.
```yaml
{
    "errors": {
        "client_name": [
        "can't be blank"
        ],
        "total_value": [
            "can't be blank"
        ]
    }
}
```

### Get the status of an Order

A client can follow the status of his order by the order reference or by his name. And if he has more than one order in his name, the system returns the status of the most recent order.

#### GET v1/orders/status/ref/:reference
#### GET v1/orders/status/client/:client_name

If there is an order with the given reference number or client name, the api will return the current order status with its reference and the http status "200 OK".
```yaml
{
    "order": {
        "reference": "BR102030",
        "status": "ready"
    }
}
```

Otherwise, an error is returned with http status "404 Not Found".

### List the Orders of a Purchase Channel

This action list all orders of a purchase channel, and also we have the possibility to restrict our listing to a single state.

#### GET v1/orders/list/:purchase_channel

An example of a successful return with a status "200 OK".

```yaml
[
    {
        "order": {
            "id": 2,
            "reference": "GOC0002",
            "purchase_channel": "SiteUK",
            "client_name": "Paulo",
            "address": "Suite 807 792 Bauch Throughway, Cartershire, NC 04672",
            "delivery_service": "SEDEX",
            "total_value": "117.57",
            "line_items": "[{Velit magni delectus hic.}, {Quis totam tempora vitae.}, {Autem fugiat nam dolorum.}]",
            "status": "sent",
            "batch_id": 1,
            "created_at": "2020-06-08T17:29:07.054Z",
            "updated_at": "2020-06-09T00:17:15.629Z"
        }
    },
    {
        "order": {
            "id": 20,
            "reference": "GOC0020",
            "purchase_channel": "SiteUK",
            "client_name": "Airton",
            "address": "453 Sanford Isle, South Lewis, RI 31230",
            "delivery_service": "FEDEX",
            "total_value": "32.23",
            "line_items": "[{Quasi consequuntur architecto debitis.}, {Possimus ad distinctio aliquid.}, {Porro eveniet quia consequatur.}]",
            "status": "sent",
            "batch_id": 1,
            "created_at": "2020-06-08T17:29:07.820Z",
            "updated_at": "2020-06-09T00:17:15.696Z"
        }
    }
]
```
It is possible to restrict our listing to a single state adding e.g. "?status=1" in the URL end. Following the status codes below.
```yaml
status: { ready: 0, production: 1, closing: 2, sent: 3 }
```
e.g. http://localhost:3000/v1/orders/list/Site%20BR?status=0

### Create a new Order

#### POST /v1/batches/create

This action creates a new Batch passing the Purchase Channel in the json request object:
```yaml
{
    "batch": {
        "purchase_channel": "Site BR"
    }
}
```

It returns a json object with the Baatch reference and the number of orders that have been added and passed to the production status with http status "201 Created". The reference is generated automatically and the system guarantees its uniqueness.
```yaml
{
    "batch": {
        "reference": "GOMVWTYVFB",
        "production_orders": 2
    }
}
```

If the purchase channel passed by reference does not exist in any orders, the API reurns htp status "404 Not Found".

### Produce a Batch

#### PATCH /v1/batches/produce/:reference

This action update all orders in a Batch to closing status. If the Batch exists and it has orders to produce it returns the reference and the amount of clonsing orders in this Batch and the http status "200 OK".
```yaml
{
    "batch": {
        "reference": "GOMVWTYVFB",
        "closing_orders": 2
    }
}
```

If the order is not found, returns status "404 Not Found".

If there are no orders to produce, returns status "400 Bad Request".

### Close part of a Batch for a Delivery Service

#### PATCH /v1/batches/close/:reference/:delivery_service

This action update all orders in a Batch with a specific delivery service to sent status. If the Batch exists, the delivery service exists and it has orders to close, it returns the reference and the amount of clonsing orders and sent orders in this Batch and the http status "200 OK".
```yaml
{
    "batch": {
        "reference": "GOMVWTYVFB",
        "closing_orders": 0,
        "sent_orders": 2
    }
}
```

If the order is not found, returns status "404 Not Found".

If there are no orders with the given delivery service, returns status "404 Not Found".

If there are no orders to produce, returns status "400 Bad Request".







