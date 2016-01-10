class TagDecorator < Draper::Decorator
  delegate_all

  def report_button
    if reported?
      h.content_tag :div, "Already reported!", class: ["btn", "btn-danger","disabled"]
    else
      h.link_to "Report tag: #{object.name}", h.restaurants_tag_report_path(tag_id:object.id), method: :post, remote: true,id: "report-tag", class: "btn btn-info"
    end
  end

  def reported?
    TagReport.where(reporter: h.current_restaurant_owner,tag: object.id).present?
  end
end
