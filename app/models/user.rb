# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  birthday               :date
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  gender                 :integer
#  job                    :string
#  name                   :string
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  uid                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_provider_and_uid      (provider,uid) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # ユーザーがパスワードを変更する際に、現在のパスワードを入力する必要があるため
  # attr_accessorは、モデルに仮想的な属性を追加するためのメソッドで、current_passwordはデータベースには保存されないが、フォームからの入力を受け取るために使用される
  attr_accessor :current_password

  has_many :games, dependent: :destroy

  enum :gender, { male: 0, female: 1 }

  validates :email, presence: true
  validates :name, presence: true
  validates :birthday, presence: true, unless: :uid?
  validates :gender, presence: true, unless: :uid?
  validates :job, presence: true, unless: :uid?

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]
  # Devise helper
  # パスワード未入力でもユーザー情報を更新できるようにする
  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

  def level
    [ games.count, 1 ].max
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid      = auth.uid
      user.email    = auth.info.email
      user.name     = auth.info.name.presence || "冒険者"
      user.password = Devise.friendly_token[0, 20] if user.new_record?
      user.save(validate: false)
    end
  end

  def password_required?
    super && provider.blank?
  end
end
