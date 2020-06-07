class BatchesController < ApplicationController
  # GET /
  def index
    @batches = Batch.all

    render json: @batches
  end

  # POST /create
  def create
    batch = Batch.new(batch_params)

    if batch.save
      render json: {batch: 
                      {id: batch.id,
                      reference: batch.reference,
                      production_orders: batch.orders.count
                      }
                    }, status: :ok
    else
      render json: batch.errors, status: :unprocessable_entity
    end
  end

  # PATCH /produce
  def produce
    @batch = Batch.find_by_reference(params['reference'])

    if @batch
      @batch.closing_status
      render json: {batch: 
                      {reference: @batch.reference,
                      closing_orders: @batch.orders.count
                      }
                    }, status: :ok
    else
      render json: { errors: { batch: 'not found' } }, status: :not_found
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def batch_params
      params.require(:batch).permit(:purchase_channel)
    end
end
