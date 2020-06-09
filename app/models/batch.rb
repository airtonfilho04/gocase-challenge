class Batch < ApplicationRecord
  has_many :orders
  before_create :set_reference, :set_orders

  validates :purchase_channel, presence: true

  # Find a batch by reference
  def self.find_by_reference(reference)
    find_by(reference: reference)
  end

  def find_orders_by_delivery(delivery_service)
    orders.where(delivery_service: delivery_service)
  end

  # Produce orders
  def status_closing
    orders.production
      .update_all(status: 2)
  end

  private
    # Define batch reference
    def set_reference
      self.reference = generete_reference
    end

    # Generate a unique batch reference
    def generete_reference
      loop do
        reference = "GO#{SecureRandom.alphanumeric(8).upcase}"
        break reference unless Batch.where(reference: reference).exists?
      end
    end

    # Select orders, set status to "production", and add to the batch
    def set_orders
      @orders = Order.list(self.purchase_channel).ready
      @orders.each do |order|
        order.status = 1
      end
      self.orders << @orders
    end
end
