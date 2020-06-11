require 'rails_helper'

describe V1::OrdersController, type: :controller do
# POST /v1/orders/create
  it 'creates a new order and should return 201 Created' do
    post :create, params: {
      order: {
        reference: 'BR000023',
        purchase_channel: 'Site BR',
        client_name: 'Airton',
        address: 'Rua Padre Valdevino, 2475 - Aldeota, Fortaleza - CE, 60135-041',
        delivery_service: 'SEDEX',
        total_value: '89,90',
        line_items: "[{ sku: case-my-best-friend, model: iPhone X, case type: Rose Leather}, { sku: powebank-sunshine, capacity: 10000mah}, {sku: earphone-standard, color: white}]"
      }
    }
    expect(response).to have_http_status(:created) 
  end

  it 'creates a new order with empty values and should return 422 Unprocessable Entity' do
    post :create, params: {
      order: {
        reference: 'BR000023',
        purchase_channel: 'Site BR',
        address: 'Rua Padre Valdevino, 2475 - Aldeota, Fortaleza - CE, 60135-041',
        delivery_service: 'SEDEX',
        total_value: '89,90',
        line_items: "[{ sku: case-my-best-friend, model: iPhone X, case type: Rose Leather}, { sku: powebank-sunshine, capacity: 10000mah}, {sku: earphone-standard, color: white}]"
      }
    }
    expect(response).to have_http_status(:unprocessable_entity) 
  end

# GET /v1/orders/status/ref/:reference
  it 'request an order status with a valid reference and should return 200 OK' do
    reference = Order.take.reference
    get :status_by_reference, params: { reference: reference }
    expect(response).to have_http_status(:ok) 
  end

  it 'request an order status with a invalid reference and should return 404 Not Found' do
    reference = "invalid_reference"
    get :status_by_reference, params: { reference: reference }
    expect(response).to have_http_status(:not_found) 
  end

# GET /v1/orders/status/client/:client_name
  it 'request an order status with a valid client name and should return 200 OK' do
    client_name = Order.take.client_name
    get :status_by_client, params: { client_name: client_name }
    expect(response).to have_http_status(:ok) 
  end

  it 'request an order status with a invalid clien name and should return 404 Not Found' do
    client_name = "invalid_name"
    get :status_by_client, params: { client_name: client_name }
    expect(response).to have_http_status(:not_found) 
  end

# GET /v1/orders/list/:purchase_channel?status=
  it 'request orders with purchase_channel and status and should return 200 OK' do
    purchase_channel = Order.take.purchase_channel
    get :list, params: { purchase_channel: purchase_channel,
                                     satus: 0 }
    expect(response).to have_http_status(:ok) 
  end

  it 'request orders with invalid purchase_channel or status and should return 404 Not Found' do
    purchase_channel = "invalid_purchase_channel"
    get :list, params: { purchase_channel: purchase_channel,
                         satus: 0 }
    expect(response).to have_http_status(:not_found) 
  end

end
