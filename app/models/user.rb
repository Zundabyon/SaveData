# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  birthday               :date
#  crypted_password       :integer
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  gender                 :boolean
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
   has_many :games, dependent: :destroy
# UserモデルとGameモデルの関連付けを行っています。
# 1人のユーザーは複数のゲームを持つことができる（1対多の関係）ことを示しています。
# dependent: :destroy オプションは、ユーザーが削除された場合に、そのユーザーに関連する全てのゲームも一緒に削除されることを意味します。



    validates :email, presence: true
    validates :name, presence: true
    validates :birthday, presence: true
    validates :gender, presence: true
# バリデーション（これはだめだよ、のルール）の追加をしています。
# presence: true は「空ではダメ」という意味です。
# これにより、email、name、birthday、genderの各属性が空でないことを保証します。
# crypted_passwordはdeviseが自動で管理するので、ここではバリデーションを追加していません。

   devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
# deviceを対応させるための記述です。
# この記述のほかに、マイグレーションファイルの作成とビューの設定が必要です。
# また、device.rbの初期設定ファイルも編集しています。(config/initializers/devise.rb)

end
