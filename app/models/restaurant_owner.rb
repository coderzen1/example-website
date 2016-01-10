class RestaurantOwner < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum registration_status: [
    :restaurant_info, :owner_additional_info,
    :restaurant_location_info, :finished
  ]
  enum ownership_verification_status: [:not_verified, :verified]

  has_many :photo_reports, as: :reporter
  has_many :tag_reports, as: :reporter

  belongs_to :address
  belongs_to :restaurant

  validates :email, presence: true
  validates :encrypted_password, presence: true
  validates :email, format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  accepts_nested_attributes_for :address
end
