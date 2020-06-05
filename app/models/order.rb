class Order < ApplicationRecord
  belongs_to :batch, optional: true
  before_create :set_initial_status
  
  enum status: { 
    ready:      0, 
    production: 1, 
    closing:    2, 
    sent:       3 
  }
  
  validates :reference, :purchase_channel, :client_name, :address,
            :delivery_service, :total_value, :line_items, presence: true

  # Find an order by reference          
  def self.find_by_reference(reference)
    find_by(reference: reference)
  end

  # Find the newest order by client name
  def self.find_newest_by_client_name(client_name)
    where(client_name: client_name).order("created_at DESC").first
  end

  # List orders by purchase_channel or by purchase_channel and status
  def self.list(purchase_channel, status = nil)
    if status.nil?
      where(purchase_channel: purchase_channel)
    else
      where({purchase_channel: purchase_channel, status: status})
    end
  end

  private
    # Set the status as "ready" when creating a new order
    def set_initial_status
      self.status = 0
    end
end
