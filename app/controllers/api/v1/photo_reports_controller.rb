module Api
  module V1
    class PhotoReportsController < Api::V1::ApplicationController
      # POST
      #   Doc
      #     Report a photo as inappropriate
      #   Params
      #     auth_token:  string
      #     id:          string or iteger
      def create
        report = PhotoReport.find_or_initialize_by(
          reporter: current_user, photo_id: params[:id]
        )

        if report.save
          expose report
        else
          error! :invalid_resource, report.errors
        end
      end

      # DELETE
      #   Doc
      #     Remove a photo report made by current user
      #   Params
      #     auth_token:       string
      #     id:               string or integer
      def destroy
        report =
          PhotoReport.find_by(
            reporter: current_user, photo_id: params[:id]
          )

        if report.present?
          report.destroy

          expose report
        else
          error! :not_found
        end
      end
    end
  end
end
