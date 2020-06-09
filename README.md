# Gocase - Backend Challenge

This project is a API Rest build in Ruby on Rails which the main purpose is to receive **Purchase Orders** from other sites and systems, group them on **Batches** and follow the Orders in the **production pipeline** until the dispatch.

* Ruby version - 2.7.1

* Rails version - 6.0.3

## Entities

### Order

|      Data       |  Type  |
|-----------------|--------|
|Reference        |String  |
|Purchase_channel |String  |
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
|Purchase_channel |String    |
|Order            |Reference |