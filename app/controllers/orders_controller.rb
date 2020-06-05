class OrdersController < ApplicationController
  # GET /orders
  def index
    @orders = Order.all

    render json: @orders, root: true
  end

  # POST /orders/create
  def create
    @order = Order.new(order_params)

    if @order.save
      render json: @order, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # GET /status/ref/:reference
  def status_by_reference
    @order = Order.find_by_reference(params['reference'])

    if @order
      render json: { order: { reference: @order.reference, status: @order.status } }, status: :ok
    else
      render json: { errors: { order: 'not found' } }, status: :not_found
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(
        :reference, :purchase_channel, :client_name, :address,
        :delivery_service, :total_value, :line_items
      )
  end
end
