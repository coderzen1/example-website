class Restaurant < ActiveRecord::Base
  include Favorable

  validates :lat, presence: true
  validates :lng, presence: true
  validates :foursquare_id, presence: true,
                            if: -> { restaurants_request_id.present? }
  validates :name, presence: true
  # validates :address, presence: true,
  #                     unless: -> { restaurants_request_id.present? }

  has_many :food_photos, class_name: Photo

  has_one :restaurant_owner

  belongs_to :address
  belongs_to :restaurants_request

  accepts_nested_attributes_for :address

  def formatted_address
    address.to_api_format
  end

  def location_present?
    lat.present? && lng.present?
  end
end
