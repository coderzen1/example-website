class CompactUserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :auth_token, :provider, :uid,
             :profile_picture, :radius
end
