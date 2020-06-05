class BatchesController < ApplicationController
  # GET /batches
  def index
    @batches = Batche.all

    render json: @batches
  end
end
