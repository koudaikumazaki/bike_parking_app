class ::Parkings::Form
  include ActiveModel::Model

  ATTRIBUTES = %i[
    name
    address
    fee
    time
    capacity
    others
    image
    image_cache
    latitude
    longitude
    fee_per_hour
    approval
    user_id
    parking
  ].freeze

  ATTRIBUTES.each { |attr| attr_accessor attr }

  validates :name, :fee, :fee_per_hour, :address, :capacity, :user_id, :latitude, :longitude, :time, presence: true
  validates :name, length: { maximum: 30 }
  validates :fee, numericality: { only_integer: true }
  validates :fee_per_hour, numericality: { only_integer: true }
  validates :address, length: { maximum: 100 }
  validates :capacity, numericality: { only_integer: true }
  validates :others, length: { maximum: 150 }
  validates :time, numericality: { only_integer: true }

  def initialize(parking, user_id, attributes = {})
    @parking = parking
    @user_id = user_id
    super(attributes)
  end

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      parking.assign_attributes(parking_params)
      parking.save!
    end
    true
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
    errors.add :base, e.message
    false
  end

  private

  def parking_params
    {
      name: name,
      address: address,
      fee: fee,
      time: time,
      capacity: capacity,
      others: others,
      image: image,
      image_cache: image_cache,
      latitude: latitude,
      longitude: longitude,
      fee_per_hour: fee_per_hour,
      approval: approval,
      user_id: user_id
    }
  end
end
