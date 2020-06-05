class OrdersController < ApplicationController
  # GET /orders
  def index
    @orders = Order.all

    render json: @orders
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

  private
    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(
        :reference, :purchase_channel, :client_name, :address,
        :delivery_service, :total_value, :line_items
      )
  end
end
