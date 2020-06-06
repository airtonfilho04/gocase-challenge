class Batch < ApplicationRecord
  has_many :orders
  after_create :set_reference

  validates :purchase_channel, presence: true

  $reference_token = 0

  private
    # Create the batch reference
    def set_reference
      self.reference = "GOC#{"%05d" % self.id}#{Time.now.year}"
    end
end
