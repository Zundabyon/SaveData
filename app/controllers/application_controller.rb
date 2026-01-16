class ApplicationController < ActionController::Base
  allow_browser versions: :modern
   # allow_browser とは
   # ブラウザのバージョンを指定し、サポートされていないブラウザからのアクセスを制限する
   # modern オプションは、最新の主要なブラウザバージョンをサポートすることを意味する

   # Deviseのストロングパラメータ設定
   # ApplicationControllerに記述することで、全てのDeviseコントローラーに適用される
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :birthday, :gender])
  end
   # ストロングパラメータで弾かれないようにするための設定
   # ここに追加したいパラメータを記述する
   # 例えば、ユーザー名を追加したい場合は、keys: [:name]のように記述する
   # このメソッドは、Deviseのコントローラーが呼び出される前に実行される
   # if文は、Deviseのコントローラーが呼び出された場合にのみ実行されるようにするためのもの
end
