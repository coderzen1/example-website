class TagReportAction < ActiveRecord::Base
  belongs_to :tag_report
  belongs_to :photo
  enum action: [:remove, :suggest]
end
