module Favorable
  extend ActiveSupport::Concern

  included do
    has_many :favorites, as: :faved

    has_many :fans,
      through: :favorites,
      source: :user
  end

end
