class Batch < ApplicationRecord
  has_many :orders
  after_create :set_reference, :set_orders

  validates :purchase_channel, presence: true

  private
    # Define the unique batch reference
    def set_reference
      self.reference = "GOC#{"%05d" % self.id}#{Time.now.year}"
    end

    def set_orders
      @orders = Order.list(self.purchase_channel).ready

      @orders.each do |order|
        order.status = 1
      end

      self.orders << @orders
    end
end
