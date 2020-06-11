require 'rails_helper'

describe V1::BatchesController, type: :controller do
# POST /v1/batches/create
  it 'creates a batch passing a existent purchase_channel and should return 201 Created' do
    purchase_channel = Order.take.purchase_channel
    post :create, params: {
      "batch": {
        "purchase_channel": purchase_channel
      }
    }
    expect(response).to have_http_status(:created) 
  end

  it 'creates a batch passing a non existent purchase_channel and should return 404 Not Found' do
    purchase_channel = "invalid_purchasechannel"
    post :create, params: {
      "batch": {
        "purchase_channel": purchase_channel
      }
    }
    expect(response).to have_http_status(:not_found) 
  end

# PATCH /v1/batches/produce/:reference
  it 'produce a batch passing a existent reference and should return 200 OK' do
    reference = Batch.take.reference
    patch :produce, params: { reference: reference }
    expect(response).to have_http_status(:ok) 
  end

  it 'produce a batch passing a non existent reference and should return 404 Not Found' do
    reference = "invalid_reeference"
    patch :produce, params: { reference: reference }
    expect(response).to have_http_status(:not_found) 
  end

  # PATCH /v1/batches/close/:reference/:delivery_service
  it 'close a batch passing a existent reference and delivery and should return 200 OK' do
    batch = Batch.find(8)
    reference = batch.reference
    delivery_service = batch.orders.take.delivery_service
    patch :close, params: { reference: reference, delivery_service: delivery_service }
    expect(response).to have_http_status(:ok) 
  end

  it 'close a batch passing a non existent reference and should return 404 Not Found' do
    batch = Batch.take
    reference = "invalid_reference"
    delivery_service = Order.where(batch_id: batch.id).take.delivery_service
    patch :close, params: { reference: reference, delivery_service: delivery_service }
    expect(response).to have_http_status(:not_found) 
  end

  it 'close a batch passing a non existent delivery_service and should return 404 Not Found' do
    batch = Batch.take
    reference = batch.reference
    delivery_service = "invalid_delivery"
    patch :close, params: { reference: reference, delivery_service: delivery_service }
    expect(response).to have_http_status(:not_found) 
  end
end
