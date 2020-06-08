module V1
  class OrdersController < ApplicationController
    # POST /orders/create
    def create
      @order = Order.new(order_params)

      if @order.save
        render json: @order, root: true, status: :created
      else
        render json: @order.errors, status: :unprocessable_entity
      end
    end

    # GET /status/ref/:reference
    def status_by_reference
      @order = Order.find_by_reference(params['reference'])

      status_json(@order)
    end

    # GET /status/client/:client_name
    def status_by_client
      @order = Order.find_newest_by_client_name(params['client_name'])

      status_json(@order)
    end

    # GET /list/:purchase_channel/:status
    def list
      @orders = Order.list(params['purchase_channel'], params['status'])

      if @orders.exists?
        render json: @orders, root: true, status: :ok
      else
        render json: { errors: { order: 'not found' } }, status: :not_found
      end
    end

    private
      # Render json for GET status actions
      def status_json(order)
        if order
          render json: order, only: [:reference, :status],
                              root: true,                     
                              status: :ok
        else
          render json: { errors: { order: 'not found' } }, status: :not_found
        end
      end
    
      # Only allow a trusted parameter "white list" through.
      def order_params
        params.require(:order).permit(
          :reference, :purchase_channel, :client_name, :address,
          :delivery_service, :total_value, :line_items
        )
      end
  end
end
