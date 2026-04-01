require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #show' do
    it '指定されたユーザーを@userに設定すること' do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user), 'ユーザーが正しく取得されていません'
    end

    it '指定されたユーザーのゲームを@gamesに設定すること' do
      game = create(:game, user: user)
      get :show, params: { id: user.id }
      expect(assigns(:games)).to include(game), 'ユーザーのゲームが正しく取得されていません'
    end
  end
end
