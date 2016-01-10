class PhotoDecorator < Draper::Decorator
  delegate_all

  def report_button
    if reported?
      h.content_tag :div, "Already reported!", class: ["btn", "btn-danger","disabled"]
    else
      h.link_to "Report", h.restaurants_photo_report_path(photo_id:object.id),
                  remote: true, method: :post, class: :"btn btn-info", id: "report-button-#{object.id}"
    end
  end

  def reported?
    object.photo_reports.find_by(reporter_id: h.current_restaurant_owner).present?
  end
end
