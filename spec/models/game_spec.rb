# == Schema Information
#
# Table name: games
#
#  id             :bigint           not null, primary key
#  difficulty     :integer
#  ended_year     :integer
#  fun            :integer
#  genre          :string
#  hardware       :string
#  igdb_cover_url :string
#  memo           :text
#  played_age     :integer
#  played_year    :integer
#  recommended    :string
#  title          :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_games_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Game, type: :model do
    describe 'ゲームの本数カウント' do
    it 'ゲームがないときはレベル1であること' do
      user = create(:user)
      expect(user.level).to eq(1), 'ユーザーのレベルが1ではありません'
    end
    it 'ゲームがあるときはレベルがゲームの本数であること' do
      user = create(:user)
      create_list(:game, 3, user: user)
      expect(user.level).to eq(3), 'ユーザーのレベルがゲームの本数と一致しません'
    end
    describe 'バリデーション' do
      context 'titleがあるとき' do
        it '有効であること' do
          game = build(:game)
          expect(game).to be_valid, 'ゲームが有効ではありません'
        end
      end

      context 'titleがないとき' do
        it '無効であること' do
          game = build(:game, title: nil)
          expect(game).not_to be_valid, 'タイトルがない場合にゲームが有効になっています'
        end
      end

      context 'played_ageがあるとき' do
        it '有効であること' do
          game = build(:game, played_age: 10)
          expect(game).to be_valid, 'プレイ年齢がある場合にゲームが有効ではありません'
        end
      end

      context 'played_ageがないとき' do
        it '無効であること' do
          game = build(:game, played_age: nil)
          expect(game).not_to be_valid, 'プレイ年齢がない場合にゲームが有効になっています'
        end
      end

      context 'played_ageが0未満のとき' do
        it '無効であること' do
          game = build(:game, played_age: -1)
          expect(game).not_to be_valid, 'プレイ年齢が0未満の場合にゲームが有効になっています'
        end
      end

      context 'played_ageが120より大きいとき' do
        it '無効であること' do
          game = build(:game, played_age: 121)
          expect(game).not_to be_valid, 'プレイ年齢が120より大きい場合にゲームが有効になっています'
        end
      end
    end
  end
end
