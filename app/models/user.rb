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
  # =========================
  # Associations
  # =========================
  has_many :games, dependent: :destroy

  # =========================
  # Enums
  # =========================
  enum gender: { male: 0, female: 1 }

  # =========================
  # Validations
  # =========================
  validates :email, presence: true
  validates :name, presence: true
  validates :birthday, presence: true
  validates :gender, presence: true
  validates :job, presence: true

  # =========================
  # Devise
  # =========================
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  # =========================
  # Story / Chapter System
  # =========================
  CHAPTERS = [
    { min: 0,  max: 1,  title: "序章",     label: "伝説の始まり" },
    { min: 2,  max: 4,  title: "第一章",   label: "目覚め" },
    { min: 5,  max: 7,  title: "第二章",   label: "旅立ち" },
    { min: 8,  max: 10, title: "第三章",   label: "仲間との出会い" },
    { min: 11, max: 13, title: "第四章",   label: "試練" },
    { min: 14, max: 16, title: "第五章",   label: "圧倒的強者との闘い" },
    { min: 17, max: 19, title: "第六章",   label: "いにしえの力" },
    { min: 20, max: 22, title: "第七章",   label: "仲間との別れ" },
    { min: 23, max: 25, title: "第八章",   label: "絶望からの復活" },
    { min: 26, max: 27, title: "第九章",   label: "みんなの力で" },
    { min: 28, max: 29, title: "第十章",   label: "全ての者たちの戦い" },
    { min: 30, max: 99, title: "最終章",   label: "SAVEDATA" }
  ].freeze

  def current_chapter
    max_age = games.where.not(played_age: nil).maximum(:played_age)
    return nil unless max_age

    CHAPTERS.find { |c| max_age.between?(c[:min], c[:max]) }
  end

  # =========================
  # Devise helper
  # =========================
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
end
