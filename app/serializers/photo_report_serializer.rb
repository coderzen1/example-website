class PhotoReportSerializer < ActiveModel::Serializer
  attributes :id, :reporter_id, :reporter_type, :photo_id
end
