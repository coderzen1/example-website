class RestaurantDecorator < Draper::Decorator
  delegate_all

  def verification_status
    if verified?
      h.content_tag :div,
                    "Ownership verified",
                    class: ["btn", "btn-success", "disabled"]
    else
      h.content_tag :div,
                    "Ownership not verified",
                    class: ["btn", "btn-danger", "disabled"]
    end
  end

  def formatted_coordinates
    if location_present?
      "N" + lat.round(4).to_s + ", W" + lng.round(4).to_s
    else
      "--"
    end
  end

  def verified?
    object.restaurant_owner.verified?
  end
end
