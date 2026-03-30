require 'rails_helper'

RSpec.describe Game, type: :model do
    describe 'ゲームの本数カウント' do
    it 'ゲームがないときはレベル1であること' do
      user = create(:user)
      expect(user.level).to eq(1)
    end
    it 'ゲームがあるときはレベルがゲームの本数であること' do
      user = create(:user)
      create_list(:game, 3, user: user)
      expect(user.level).to eq(3)
    end
    describe 'バリデーション' do
      context 'titleがあるとき' do
        it '有効であること' do
          game = build(:game)
          expect(game).to be_valid
        end
      end

      context 'titleがないとき' do
        it '無効であること' do
          game = build(:game, title: nil)
          expect(game).not_to be_valid
        end
      end

      context 'played_ageがあるとき' do
        it '有効であること' do
          game = build(:game, played_age: 10)
          expect(game).to be_valid
        end
      end

      context 'played_ageがないとき' do
        it '無効であること' do
          game = build(:game, played_age: nil)
          expect(game).not_to be_valid
        end
      end

      context 'played_ageが0未満のとき' do
        it '無効であること' do
          game = build(:game, played_age: -1)
          expect(game).not_to be_valid
        end
      end

      context 'played_ageが120より大きいとき' do
        it '無効であること' do
          game = build(:game, played_age: 121)
          expect(game).not_to be_valid
        end
      end
    end
  end
end
