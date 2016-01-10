class  GeneralInfoForm
  include ActiveModel::Model

  extend CarrierWave::Mount
  include CarrierWave::Validations::ActiveModel
  attr_accessor :restaurant_name, :owner_name,
  :owner_birthday, :ownership_document, :user


  validates :restaurant_name, presence: true
  validates :owner_name, presence: true
  validates :owner_birthday, presence: true

  # validates_integrity_of :ownership_document
  mount_uploader :ownership_document, OwnershipDocumentUploader


  def save
    return false if invalid?
    persist_data
    true
  end

  private

  def persist_data
    restaurant.update(name: restaurant_name, ownership_document: ownership_document)
    user.update(name: owner_name, birthday: owner_birthday)
  end

  def restaurant
    @restaurant ||= user.restaurant
  end
end
