class Batch < ApplicationRecord
  has_many :orders
  before_create :set_reference, :set_orders

  validates :purchase_channel, presence: true

  # Find a batch by reference
  def self.find_by_reference(reference)
    find_by(reference: reference)
  end

  def closing_status
    @orders = Order.production.where(batch_id: self.id)
    @orders.update_all(status: 2)
  end

  private
    # Define the unique batch reference
    def set_reference
      self.reference = generete_reference
    end

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
