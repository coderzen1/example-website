module SuperUsers
  class PhotoReportAbuseService
    WRONGFUL_REPORTS_LIMIT = 3

    def initialize(photo)
      @photo = photo
    end

    def check_abuse!
      flag_user! if deleted_photos_count >= WRONGFUL_REPORTS_LIMIT
    end

    private

    attr_reader :photo

    def deleted_photos_count
      Photo.removed.where(owner_id: photo.owner_id).count
    end

    def flag_user!
      user.flagged = true
      user.save
    end

    def user
      @user ||= User.find(photo.owner_id)
    end
  end
end
