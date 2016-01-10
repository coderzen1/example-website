module RestaurantOwners
  class TagReportActionsController < AuthorizedController
    def update
      @report = TagReport.find(params[:id])
      @report.update(report_action_params)
    end

    private

    def report_action_params
      params.require(:tag_report)
        .permit(tag_report_actions_attributes: [:photo_id, :tag_suggestion, :action])
    end
  end
end
