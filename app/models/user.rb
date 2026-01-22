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
#  job                    :string
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
 CHAPTERS = [
    { min: 0,  max: 5,  title: "序章",   label: "はじまりの記録" },
    { min: 6,  max: 12, title: "第一章", label: "目覚め" },
    { min: 13, max: 18, title: "第二章", label: "熱狂" },
    { min: 19, max: 25, title: "第三章", label: "旅立ち" },
    { min: 26, max: 35, title: "第四章", label: "試練" },
    { min: 36, max: 45, title: "第五章", label: "深化" },
    { min: 46, max: 55, title: "第六章", label: "継承" },
    { min: 56, max: 65, title: "第七章", label: "円熟" },
    { min: 66, max: 75, title: "第八章", label: "回想" },
    { min: 76, max: 85, title: "第九章", label: "余韻" },
    { min: 86, max: 99, title: "終章",   label: "セーブデータ" }
  ]

  def current_chapter
    max_age = games.where.not(played_age: nil).maximum(:played_age)
    return nil unless max_age

    CHAPTERS.find { |c| max_age.between?(c[:min], c[:max]) }
  end


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
# パスワードなしでユーザー情報を更新
def update_without_current_password(params, *options)
  params.delete(:current_password)

  # パスワードが空なら削除
  if params[:password].blank? && params[:password_confirmation].blank?
    params.delete(:password)
    params.delete(:password_confirmation)
  end

  result = update(params, *options)
  clean_up_passwords
  result
end