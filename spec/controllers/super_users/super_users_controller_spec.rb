require 'rails_helper'
RSpec.describe SuperUsers::SuperUsersController, type: :controller do
  let(:super_user) { create(:super_user) }
  let!(:super_user2) { create(:super_user) }
  let(:super_user3) { attributes_for(:super_user) }

  before do
    sign_in super_user
  end

  describe "POST #create" do
    context "when valid" do
      it "should create super_user" do
        expect { post :create, super_user: super_user3.as_json }.to change(SuperUser, :count).by(1)
        expect(response).to redirect_to(admin_super_users_path)
      end
    end
  end

  describe "POST #create" do
    context "when invalid" do
      it "should render new" do
        super_user3[:password] = ''

        post :create, super_user: super_user3.as_json

        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #new" do
    it "should render super_user form" do
      get :new

      expect(response).to render_template(:new)
      expect(response).to be_success
    end
  end

  describe "PUT #update" do
    context "when valid" do
      it "should update super user" do
        put :update, id: super_user2, super_user: super_user2.as_json

        expect(response).to redirect_to(admin_super_users_path)
      end
    end
  end

  describe "PUT #update" do
    context "when invalid" do
      it "should render edit" do
        super_user2.email = ''

        put :update, id: super_user2, super_user: super_user2.as_json

        expect(response).to render_template(:edit)
      end
    end
  end

  describe "GET #edit" do
    it "should render edit form" do
      get :edit, id: super_user2

      expect(response).to render_template(:edit)
      expect(response).to be_success
    end
  end

  describe "GET #index" do
    it "should return all super_users" do
      get :index

      expect(response).to render_template(:index)
      expect(response).to be_success
    end
  end

  describe "DELETE #destroy" do
    it "should delete super_user" do

      expect { xhr :delete, :destroy, id: super_user2 }.to change(SuperUser, :count).by(-1)
    end
  end
end
