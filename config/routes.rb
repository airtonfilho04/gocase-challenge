Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope :orders do
    get  '/', to: 'orders#index', as: 'orders_index'
  end

  scope :batches do
    get '/', to: 'batches#index', as: 'batches_index'
  end
end
