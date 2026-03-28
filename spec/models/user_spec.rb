require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    context 'emailがあるとき' do
      it '有効であること' do
        # emailありのユーザーを作る
        user = build(:user)
        # 有効か確認
        expect(user).to be_valid
      end
    end

    context 'emailがないとき' do
      it '無効であること' do
        # emailなしのユーザーを作る
        user = build(:user, email: nil)
        # 無効か確認
        expect(user).not_to be_valid
      end
    end
  end
end