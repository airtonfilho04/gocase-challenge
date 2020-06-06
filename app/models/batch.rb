class Batch < ApplicationRecord
  has_many :orders
  before_create :set_reference

  validates :purchase_channel, presence: true

  $reference_token = 0

  private
    # Create the batch reference
    def set_reference
      if Batch.last.nil?
        last_batch_id = 1
      else
        last_batch_id = Batch.last.id + 1
      end
      self.reference = "GOC#{Time.now.year}#{"%05d" % last_batch_id}"
    end
end
