require 'rails_helper'

describe Api::V1::PhotoReportsController do
  default_version 1

  let(:user) { create(:user) }
  let(:photo) { create(:photo, owner: user) }

  describe 'POST #create' do
    context 'when correctly creating a report' do
      it 'should create a new PhotoReport' do
        expect do
          post :create, auth_token: user.auth_token, id: photo.id
        end.to change(PhotoReport, :count).by(1)
      end

      it 'should return the report' do
        post :create, auth_token: user.auth_token, id: photo.id

        expect(response).to have_exposed(PhotoReport.first)
      end
    end

    context 'when incorrectly creating a report' do
      it 'should not create a new PhotoReport' do
        expect do
          post :create, auth_token: user.auth_token, id: 0
        end.not_to change(PhotoReport, :count)
      end

      it 'should raise invalid resource error' do
        post :create, auth_token: user.auth_token, id: 0

        expect(response).to be_api_error(RocketPants::InvalidResource)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:photo_report) { create(:photo_report, reporter: user, photo: photo) }

    context 'when sending correct data' do
      it 'should destroy a PhotoReport' do
        expect do
          delete :destroy, auth_token: user.auth_token, id: photo.id
        end.to change(PhotoReport, :count).by(-1)
      end

      it 'should return the report' do
        delete :destroy, auth_token: user.auth_token, id: photo.id

        expect(response).to have_exposed(photo_report)
      end
    end

    context 'when not sending correct data' do
      it 'should not destroy a PhotoReport' do
        expect do
          delete :destroy, auth_token: user.auth_token, id: 0
        end.not_to change(PhotoReport, :count)
      end

      it 'should raise resource_not_found error' do
        delete :destroy, auth_token: user.auth_token, id: 0

        expect(response).to be_api_error(RocketPants::NotFound)
      end
    end
  end
end
