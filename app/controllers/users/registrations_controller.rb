class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # パスワードなしで更新
  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  # 更新後はダッシュボードへリダイレクト
  def after_update_path_for(resource)
    dashboard_path
  end
end
