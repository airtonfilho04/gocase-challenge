Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope :orders do
    get  '/', 
         to: 'orders#index', as: 'orders_index'
    post '/create', 
         to: 'orders#create', as: 'orders_create'
    get  '/status/ref/:reference', 
         to: 'orders#status_by_reference', as: 'status_by_reference'
    get  '/status/client/:client_name', 
         to: 'orders#status_by_client', as: 'status_by_client'
    get  '/list/:purchase_channel', 
         to: 'orders#list', as: 'list_orders'
  end

  scope :batches do
    get  '/', 
         to: 'batches#index', as: 'batches_index'
    post '/create',
         to: 'batches#create', as: 'batches_create'
  end
end
