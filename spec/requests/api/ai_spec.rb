require 'rails_helper'

RSpec.describe "Api::Ais", type: :request do
  describe "GET /recommend" do
    it "returns http success" do
      get "/api/ai/recommend"
      expect(response).to have_http_status(:success)
    end
  end
end
