class Photo < ActiveRecord::Base
  include Favorable

  acts_as_taggable

  serialize :parameters, JSON

  belongs_to :owner, polymorphic: true
  belongs_to :restaurant
  has_many :photo_reports
  has_many :tag_report_actions

  validates :image, presence: true
  validates :caption, presence: true
  validates :restaurant, presence: true
  enum status: [:approved, :removed]

  mount_uploader :image, PhotoUploader

  scope :deleted, -> { where.not(deleted_at: nil) }
  scope :not_deleted, -> { where(deleted_at: nil) }

  def delete!
    update(deleted_at: Time.zone.now)
  end

  def undelete!
    update(deleted_at: nil)
  end
end
