module V1
  class BatchesController < ApplicationController
    # POST /create
    def create
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

    # PATCH /produce
    def produce
      @batch = Batch.find_by_reference(params['reference'])

      if @batch.nil?
        render json: { errors: { batch: 'not found' } }, status: :not_found
      else
        @batch.status_closing
        render json: {batch: 
                        {reference: @batch.reference,
                        closing_orders: @batch.orders.closing.count
                        }
                      }, status: :ok
      end
    end

    # PATCH /close
    def close
      @batch = Batch.find_by_reference(params['reference'])

      if @batch.nil?
        render json: { errors: { batch: 'not found' } }, status: :not_foun
      else
        @batch.status_sent(params['delivery_service'])
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
        params.require(:batch).permit(:reference, :purchase_channel, :delivey_service)
      end
  end
end
