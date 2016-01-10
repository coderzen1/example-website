require 'rails_helper'

describe FoursquarePicturesJob do
  let(:lateral) { create(:lateral) }

  let(:foursquare_photo_response) do
    File.new(
      "#{Rails.root}/spec/api_responses/foursquare/pictures_response.json"
    )
  end


  before do
    stub_request(
      :get,
      %r{https://api.foursquare.com/v2/venues/3sda43er8/photos\?.*}
    ).to_return(status: 200, body: foursquare_photo_response)
  end

  describe "when sending a valid restaurant id" do
    it "should add a picture" do
      perform_enqueued_jobs { FoursquarePicturesJob.perform_now(lateral.id) }

      expect(lateral.reload.photo)
        .to eq(
          "https://irs3.4sqi.net/img/general/960x712/4116637_MWYIVebNrZ0wDIVquF_pd0pCK9AEvwy92RN4ZZEviBI.jpg"
        )
    end
  end
end
