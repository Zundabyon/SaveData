require 'rails_helper'

RSpec.describe DashboardsController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET #show' do
    it '現在のユーザーが@userに設定されること' do
      get :show
      expect(assigns(:user)).to eq(user), '現在のユーザーが正しく割り当てられていません'
    end

    it '現在のユーザーのゲームが@gamesに設定されること' do
      game = create(:game, user: user)
      get :show
      expect(assigns(:games)).to include(game), '現在のユーザーのゲームが取得されていません'
    end
  end
end
