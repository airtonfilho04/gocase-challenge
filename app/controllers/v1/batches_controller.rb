module V1
  class BatchesController < ApplicationController
    # POST /v1/batches/create
    def create
      if not check_purchase_channel(params['purchase_channel'])
        render json: { errors: { purchase_channel: 'not found' } }, status: :not_found
      else
        @batch = Batch.new(batch_params)

        if @batch.save
          render json: {batch: 
                          {reference: @batch.reference,
                          production_orders: @batch.orders.count
                          }
                        }, status: :ok
        else
          render json: @batch.errors, status: :unprocessable_entity
        end
      end
    end

    # PATCH /v1/batches/produce
    def produce
      @batch = Batch.find_by_reference(params['reference'])

      if @batch.nil?
        render json: { errors: { batch: 'not found' } }, status: :not_found
      elsif not @batch.orders.production.exists?
        render json: { errors: { batch: 'no orders to produce' } }, status: :bad_request
      else
        @batch.status_closing
        render json: {batch: 
                        {reference: @batch.reference,
                        closing_orders: @batch.orders.closing.count
                        }
                      }, status: :ok
      end
    end

    # PATCH /v1/batches/close
    def close
      @batch = Batch.find_by_reference(params['reference'])
      @orders = @batch.group_orders_by_delivery(params['delivery_service'])

      if @batch.nil?
        render json: { errors: { batch: 'not found' } }, status: :not_found
      elsif not @orders.exists?
        render json: { errors: { delivery_service: 'not found' } }, status: :not_found
      elsif not @orders.closing.exists?
        render json: { errors: { batch: 'no orders to close' } }, status: :bad_request
      else
        @orders.update_all(status: 3)
        render json: {batch: 
                        {reference: @batch.reference,
                        closing_orders: @batch.orders.closing.count,
                        sent_orders: @batch.orders.sent.count
                        }
                      }, status: :ok
      end
    end

    private
      # Only allow a trusted parameter "white list" through.
      def batch_params
        params.require(:batch).permit(:purchase_channel)
      end

      # Check if the Purchase Channel exists
      def check_purchase_channel(purchase_channel)
        Order.all.where(purchase_channel: purchase_channel).exists?
      end
  end
end
