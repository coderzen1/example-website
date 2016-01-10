class PhotosController < ApplicationController
  INSTAGRAM_ACCESS_TOKEN = "2116765088.4365af2.f8f72bd623d844bfb8b780043481e77c"
  FOODFAVES_INSTAGRAM_ACCOUNT_ID = 1478237841
  INFINUM_INSTAGRAM_ACCESS_TOKEN = "675831767.4365af2.093c613d8d564c4d85c805a79c7661f1"

  STROJARSKA_LAT = 45.8039401
  STROJARSKA_LNG = 15.9895105

  def index
    feed =
      Instagram::RecentMedia
      .new(FOODFAVES_INSTAGRAM_ACCOUNT_ID)
      .items_with_location_present_in_json

    render json: feed
  end

  def discover
    discover_service = DiscoverScreenService.new(discover_params)

    if discover_service.valid?
      render json: discover_service.call,
             each_serializer: DiscoverPhotoFrontendSerializer,
             root: false
    else
      render json: { error: :invalid_resource,
                     error_description: discover_service.errors }
    end
  end

  private

  def discover_params
    params.permit(:per_page).merge(lat: latitude, lng: longitude)
  end

  def latitude
    geocoded_latitude.zero? ? STROJARSKA_LAT : geocoded_latitude
  end

  def longitude
    geocoded_longitude.zero? ? STROJARSKA_LNG : geocoded_longitude
  end

  def geocoded_latitude
    @geocoded_latitude ||= request.location.latitude.to_f
  end

  def geocoded_longitude
    @geocoded_longitude ||= request.location.longitude.to_f
  end

end
