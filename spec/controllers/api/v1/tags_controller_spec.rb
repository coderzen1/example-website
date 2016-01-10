require 'rails_helper'

describe Api::V1::TagsController do
  default_version 1

  let(:user) { create(:user) }

  before do
    create(:penne_creamy)
    create(:penne_vodka)
  end

  describe "GET #index" do
    it 'gets all tags beginning with the search string' do
      get :index, search: 'Penne', auth_token: user.auth_token
      expect(response.decoded_body["count"]).to eq(2)
    end

    it 'gets all tags beginning with the search string case insensitive' do
      get :index, search: 'penne', auth_token: user.auth_token
      expect(response.decoded_body["count"]).to eq(2)
    end

    it 'gets no tags if search string is empty' do
      get :index, auth_token: user.auth_token
      expect(response.decoded_body["count"]).to eq(0)
    end

    it 'gets no tags if search string is unmatching to anything' do
      get :index, auth_token: user.auth_token, search: 'parambarambarambaba'
      expect(response.decoded_body["count"]).to eq(0)
    end
  end
end
