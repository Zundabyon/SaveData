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
        user = build(:user, password: "password", password_confirmation: "password")
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

  describe 'update_without_current_password' do
    it 'nameを更新できること' do
      user = create(:user)
      user.update_without_current_password(name: '新しい名前')
      expect(user.reload.name).to eq('新しい名前')
    end

    it 'passwordが空のとき削除されること' do
      user = create(:user)
      result = user.update_without_current_password(
        name: '新しい名前',
        password: '',
        password_confirmation: ''
      )
      expect(result).to be true
    end
  end

  describe 'from_omniauth' do
    it '新規ユーザーが作成されること' do
      auth = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '123456789',
        info: {
          email: 'test@example.com',
          name: 'テストユーザー'
        }
      })
      user = User.from_omniauth(auth)
      expect(user.provider).to eq('google_oauth2')
      expect(user.uid).to eq('123456789')
    end

    it 'nameがないとき冒険者になること' do
      auth = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '987654321',
        info: {
          email: 'test2@example.com',
          name: ''
        }
      })
      user = User.from_omniauth(auth)
      expect(user.name).to eq('冒険者')
    end
  end

  describe 'password_required?' do
    it 'providerがないときtrueを返すこと' do
      user = build(:user)
      expect(user.password_required?).to be true
    end

    it 'providerがあるときfalseを返すこと' do
      user = build(:user, :google_oauth2)
      expect(user.password_required?).to be false
    end
  end
end