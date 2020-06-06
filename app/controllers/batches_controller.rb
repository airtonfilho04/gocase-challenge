class BatchesController < ApplicationController
  # GET /
  def index
    @batches = Batche.all

    render json: @batches
  end

  # POST /create
  def create
    @batch = Batch.new(batch_params)

    if @batch.save
      render json: @batch, root: true, status: :created
    else
      render json: @batch.errors, status: :unprocessable_entity
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def batch_params
      params.require(:batch).permit(:purchase_channel)
    end
end
