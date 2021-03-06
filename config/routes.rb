Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  api_version(:module => "V1", :path => {:value => "v1"}) do
    scope :orders do
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
      post  '/create',
            to: 'batches#create', as: 'batches_create'
      patch '/produce/:reference',
            to: 'batches#produce', as: 'batches_produce'
      patch '/close/:reference/:delivery_service',
            to: 'batches#close', as: 'batches_close'
    end
  end
end
