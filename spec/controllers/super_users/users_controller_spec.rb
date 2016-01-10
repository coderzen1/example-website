require 'rails_helper'
RSpec.describe SuperUsers::UsersController, type: :controller do
  let(:super_user) { SuperUser.create(email: "fkuster@foi.hr", password: "12345678") }
  let!(:user) { create(:user) }

  before do
    sign_in super_user
  end

  describe "DELETE #destroy" do
    it "change user status to deleted" do
      xhr :delete, :destroy, id: user

      expect { user.reload }.to change(user, :status).from("normal").to("deleted")
    end
  end

  describe "GET #lock" do
    it "change user status to locked" do
      xhr :get, :lock, id: user

      expect { user.reload }.to change(user, :status).from("normal").to("locked")
    end
  end

  describe "GET #restore" do
    it "change user status to normal" do
      user.deleted!
      xhr :get, :restore, id: user

      expect { user.reload }.to change(user, :status).from("deleted").to("normal")
    end
  end

  describe "GET #unlock" do
    it "change user status to normal" do
      user.locked!
      xhr :get, :unlock, id: user

      expect { user.reload }.to change(user, :status).from("locked").to("normal")
    end
  end

  describe "GET #index" do
    it "return all deleted users" do
      get :index, deleted: true

      expect(response).to be_success
    end
  end

  describe "GET #index" do
    it "return all flagged users" do
      get :index, flagged: true

      expect(response).to be_success
    end
  end

  describe "GET #index" do
    it "return all normal users" do
      get :index

      expect(response).to be_success
    end
  end
end
