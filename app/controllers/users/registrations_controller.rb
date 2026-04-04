class Users::RegistrationsController < Devise::RegistrationsController
  # Deviseのコントローラーを継承して、ユーザー登録や更新の挙動をカスタマイズするためのコントローラー
  protected
  # protectedにすることで、外部から直接アクセスできないようにする

  # パスワードなしで更新できるようにする
  def update_resource(resource, params)
    # パスワード変更がある場合
    if params[:password].present?

      # 現在のパスワードを確認
      if params[:current_password].present? &&
         resource.valid_password?(params[:current_password])

        # パスワード変更を含む更新
        resource.update(params.except(:current_password))
      else
        # 現在のパスワードが正しくない
        resource.errors.add(:current_password, "現在のパスワードが正しくありません")
        false
      end
    else

      # パスワード変更なしの更新
      # current_password も除外する
      resource.update_without_current_password(
        params.except(:current_password, :password, :password_confirmation)
      )
    end
  end

  # 更新後のリダイレクト先を指定
  def after_update_path_for(resource)
    edit_user_registration_path
  end
end
