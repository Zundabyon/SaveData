require 'rails_helper'

RSpec.describe "Uranais", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/uranai/index"
      expect(response).to have_http_status(:success)
    end
  end
end
