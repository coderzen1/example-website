module FoodFave
  module Foursquare

    API_VERSION = '20140505'

    def self.client
      Foursquare2::Client.new(client_id: Rails.application.secrets.foursquare_client_id,
                              client_secret: Rails.application.secrets.foursquare_client_secret,
                              api_version: API_VERSION)
    end
  end
end
