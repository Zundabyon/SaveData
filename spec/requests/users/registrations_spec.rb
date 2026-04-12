require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  let(:user) { create(:user) }
  let(:browser_headers) do
    {
      'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    }
  end

  before do
    sign_in user, scope: :user
    ActionController::Base.allow_forgery_protection = false
  end

  after do
    ActionController::Base.allow_forgery_protection = true
  end

  describe "PATCH /users/registration" do
    context "パスワードなしで更新するとき" do
      it "プロフィールが更新されること" do
        patch user_registration_path, params: {
          user: {
            name: "新しい名前",
            email: user.email,
            current_password: "",
            password: "",
            password_confirmation: ""
          }
        }, headers: browser_headers
        expect(response).to redirect_to(edit_user_registration_path)
      end
    end

    context "正しいパスワードで更新するとき" do
      it "パスワードが更新されること" do
        patch user_registration_path, params: {
          user: {
            name: user.name,
            email: user.email,
            current_password: "password123",
            password: "newpassword123",
            password_confirmation: "newpassword123"
          }
        }, headers: browser_headers
        expect(response).to redirect_to(edit_user_registration_path)
      end
    end

    context "間違ったパスワードで更新するとき" do
      it "エラーになること" do
        patch user_registration_path, params: {
          user: {
            name: user.name,
            email: user.email,
            current_password: "wrongpassword",
            password: "newpassword123",
            password_confirmation: "newpassword123"
          }
        }, headers: browser_headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end