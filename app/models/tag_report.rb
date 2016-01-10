class TagReport < ActiveRecord::Base
  belongs_to :reporter, polymorphic: true
  belongs_to :tag, class_name: ActsAsTaggableOn::Tag
  has_many :tag_report_actions
  accepts_nested_attributes_for :tag_report_actions

  validates :reporter, presence: true
  validates :tag, presence: true
  validates :tag, uniqueness: { scope: :reporter }
end
