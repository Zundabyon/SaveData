class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    begin
      Rails.logger.info "OmniAuth auth data: #{request.env["omniauth.auth"].inspect}"
      @user = User.from_omniauth(request.env["omniauth.auth"])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
      else
        session["devise.google_data"] = request.env["omniauth.auth"].except("extra")
        redirect_to new_user_registration_url, alert: @user.errors.full_messages.join(", ")
      end
    rescue => e
      Rails.logger.error "Google OAuth error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      redirect_to root_path, alert: "Googleログインでエラーが発生しました。#{e.message}"
    end
  end

  def failure
    redirect_to root_path, alert: "Googleログインに失敗しました。"
  end
end
