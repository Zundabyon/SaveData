require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET #terms' do
    it '200 OKを返すこと' do
      get :terms
      expect(response).to have_http_status(:success), 'HTTPステータスが成功ではありません'
    end
  end

  describe 'GET #privacy_policy' do
    it '200 OKを返すこと' do
      get :privacy_policy
      expect(response).to have_http_status(:success), 'HTTPステータスが成功ではありません'
    end
  end

  describe 'GET #how_to' do
    it '200 OKを返すこと' do
      get :how_to
      expect(response).to have_http_status(:success), 'HTTPステータスが成功ではありません'
    end
  end
end
