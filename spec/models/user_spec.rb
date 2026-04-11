# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  birthday               :date
#  crypted_password       :integer
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
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    context 'emailがあるとき' do
      it '有効であること' do
        user = build(:user)
        expect(user).to be_valid
      end
    end

    context 'emailがないとき' do
      it '無効であること' do
        user = build(:user, email: nil)
        expect(user).not_to be_valid
      end
    end

    context 'nameがあるとき' do
      it '有効であること' do
        user = build(:user, name: "John Doe")
        expect(user).to be_valid
      end
    end

    context 'nameがないとき' do
      it '無効であること' do
        user = build(:user, name: nil)
        expect(user).not_to be_valid
      end
    end

    context 'passwordがあるとき' do
      it '有効であること' do
        user = build(:user, password: "password")
        expect(user).to be_valid
      end
    end
    context 'passwordがないとき' do
      it '無効であること' do
        user = build(:user, password: nil)
        expect(user).not_to be_valid
      end
    end

      context 'genderがあるとき' do
      it '有効であること' do
        user = build(:user, gender: "male")
        expect(user).to be_valid
      end
    end
    context 'genderがないとき' do
      it '無効であること' do
        user = build(:user, gender: nil)
        expect(user).not_to be_valid
      end
    end

    context 'jobがあるとき' do
      it '有効であること' do
        user = build(:user, job: "engineer")
        expect(user).to be_valid
      end
    end
    context 'jobがないとき' do
      it '無効であること' do
        user = build(:user, job: nil)
        expect(user).not_to be_valid
      end
    end

    # === OAuthユーザー用のバリデーションチェック ===
    context 'OAuthユーザー（Google）のとき' do
      it 'birthdayがなくても有効であること' do
        user = build(:user, :google_oauth2)
        expect(user).to be_valid
      end

      it 'genderがなくても有効であること' do
        user = build(:user, :google_oauth2)
        expect(user).to be_valid
      end

      it 'jobがなくても有効であること' do
        user = build(:user, :google_oauth2)
        expect(user).to be_valid
      end
    end
  end
end
