class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  # Deviseのストロングパラメータ設定
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def after_sign_in_path_for(resource)
    authenticated_root_path  # または dashboard_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :name,
      :birthday,
      :gender,
      :job
    ])

    devise_parameter_sanitizer.permit(:account_update, keys: [
      :name,
      :birthday,
      :gender,
      :job
    ])
  end
end
