require 'rails_helper'

RSpec.describe ShareImagesController, type: :controller do
  describe 'POST #create' do
    # 1x1透明PNGのBase64データ
    let(:image_data) do
      'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg=='
    end

    it 'JSONレスポンスを返すこと' do
      post :create, params: { image: image_data }
      expect(response).to have_http_status(:success), 'JSONレスポンスが返されていません'
    end

    it 'レスポンスにURLが含まれること' do
      post :create, params: { image: image_data }
      json = JSON.parse(response.body)
      expect(json).to have_key('url'), 'レスポンスにURLが含まれていません'
    end
  end
end
