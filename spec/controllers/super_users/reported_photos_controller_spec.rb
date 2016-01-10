require 'rails_helper'
RSpec.describe SuperUsers::ReportedPhotosController, type: :controller do
  let(:super_user) { SuperUser.create(email: "fkuster@foi.hr", password: "12345678") }
  let!(:photo) { create(:photo) }
  let!(:photo_report) { create(:photo_report, photo: photo) }
  let!(:photo_report2) { create(:photo_report, photo: photo) }
  let!(:tag) { create(:tag) }


  before do
    sign_in super_user
  end

  describe "GET #index" do
    it "should render index page" do
      get :index
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end

  describe "POST #approve" do
    it "should delete photo reports" do
      expect { xhr :post, :approve, id: photo }.to change(PhotoReport, :count).by(-2)
    end
  end

  describe "POST #remove" do
    it "change photo status to removed" do
      xhr :post, :remove, id: photo

      expect { photo.reload }.to change(photo, :status).from("approved").to("removed")
    end
  end

  describe "POST #remove_tag" do
    it "should delete this tag from tag_list" do
      photo.tag_list.add(tag.name)
      photo.save

      xhr :post, :remove_tag, photo_id: photo, id: tag.id

      expect { photo.reload }.to change(photo, :tag_list).to([])
    end
  end
end
