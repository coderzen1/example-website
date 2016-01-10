class PhotoReport < ActiveRecord::Base
  belongs_to :reporter, polymorphic: true
  belongs_to :photo

  validates :reporter, presence: true
  validates :photo, presence: true
  validates :photo, uniqueness: { scope: :reporter }
end
