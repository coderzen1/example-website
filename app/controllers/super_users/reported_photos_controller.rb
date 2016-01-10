module SuperUsers
  class ReportedPhotosController < AuthorizedController
    def index
      @photos =
        Photo.approved
        .where(id: PhotoReport.pluck(:photo_id))
        .paginate(page: params[:page], per_page: 4)
    end

    def approve
      @photo = Photo.find(params[:id])
      @photo.photo_reports.destroy_all
    end

    def remove
      @photo = Photo.find(params[:id])
      @photo.removed!
      PhotoReportAbuseService.new(@photo).check_abuse!
    end

    def remove_tag
      @photo = Photo.find(params[:photo_id])
      @photo.tag_list.remove(ActsAsTaggableOn::Tag.find(params[:id]).name)
      @photo.save
    end
  end
end
