require 'rails_helper'

describe V1::OrdersController, type: :controller do
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

  it 'request a order status with a valid reference and should return 200 OK' do
    reference = Order.first.reference
    get :status_by_reference, params: { reference: reference }
    expect(response).to have_http_status(:ok) 
  end
end
