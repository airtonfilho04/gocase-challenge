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

  def self.find_by_reference(reference)
    find_by(reference: reference)
  end

  def self.find_newest_by_client_name(client_name)
    where(client_name: client_name).order("created_at DESC").first
  end

  private
    # Set the status as "ready" when creating a new order
    def set_initial_status
      self.status = 0
    end
end
