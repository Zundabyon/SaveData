class User < ApplicationRecord
  # Associations
  has_many :games, dependent: :destroy
  # Enums
  enum gender: { male: 0, female: 1 }
  # Validations
  validates :email, presence: true
  validates :name, presence: true
  validates :birthday, presence: true, unless: :uid?
  validates :gender, presence: true, unless: :uid?
  validates :job, presence: true, unless: :uid?
  # Devise
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def current_chapter
    game_count = games.count
    CHAPTERS.find { |c| game_count.between?(c[:min], c[:max]) }
  end

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
