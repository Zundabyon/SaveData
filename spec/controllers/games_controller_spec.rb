require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  let(:user) { create(:user) }
  let(:game) { create(:game, user: user) }

  before do
    sign_in user
  end

  describe 'GET #new' do
    it '新しいゲームを準備すること' do
      get :new
      expect(assigns(:game)).to be_a_new(Game), '新しいゲームが準備されていません'
    end

    it '新しいゲームのユーザーが現在のユーザーであること' do
      get :new
      expect(assigns(:game).user).to eq(user), '新しいゲームのユーザーが正しく設定されていません'
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { attributes_for(:game, title: 'Test Game', played_age: 10) }
    let(:invalid_attributes) { attributes_for(:game, title: nil) }

    context '有効なパラメータの場合' do
      it 'ゲームが1件増えること' do
        expect {
          post :create, params: { game: valid_attributes }
        }.to change(Game, :count).by(1), '新しいゲームが作成されていません'
      end

      it 'ダッシュボードにリダイレクトされること' do
        post :create, params: { game: valid_attributes }
        expect(response).to redirect_to(dashboard_path), 'ダッシュボードにリダイレクトされていません'
      end
    end

    context '無効なパラメータの場合' do
      it 'ゲームが増えないこと' do
        expect {
          post :create, params: { game: invalid_attributes }
        }.not_to change(Game, :count), 'ゲームが作成されてしまっています'
      end

      it 'newテンプレートを再レンダリングすること' do
        post :create, params: { game: invalid_attributes }
        expect(response).to render_template(:new), 'newテンプレートが表示されていません'
      end
    end
  end

  describe 'GET #edit' do
    it '指定されたゲームを取得すること' do
      get :edit, params: { id: game.id }
      expect(assigns(:game)).to eq(game), '編集対象のゲームが取得されていません'
    end
  end

  describe 'PUT #update' do
    let(:new_attributes) { { title: 'New Title' } }
    let(:invalid_attributes) { { title: nil } }

    context '有効なパラメータの場合' do
      it 'ゲームのタイトルが更新されること' do
        put :update, params: { id: game.id, game: new_attributes }
        expect(game.reload.title).to eq('New Title'), 'ゲームのタイトルが更新されていません'
      end

      it 'ダッシュボードにリダイレクトされること' do
        put :update, params: { id: game.id, game: new_attributes }
        expect(response).to redirect_to(dashboard_path), 'ダッシュボードにリダイレクトされていません'
      end
    end

    context '無効なパラメータの場合' do
      it 'ゲームが更新されないこと' do
        original_title = game.title
        put :update, params: { id: game.id, game: invalid_attributes }
        expect(game.reload.title).to eq(original_title), 'ゲームのタイトルが変更されてしまっています'
      end

      it 'editテンプレートを再レンダリングすること' do
        put :update, params: { id: game.id, game: invalid_attributes }
        expect(response).to render_template(:edit), 'editテンプレートが表示されていません'
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'ゲームが1件減ること' do
      game
      expect {
        delete :destroy, params: { id: game.id }
      }.to change(Game, :count).by(-1), 'ゲームが削除されていません'
    end

    it 'ダッシュボードにリダイレクトされること' do
      delete :destroy, params: { id: game.id }
      expect(response).to redirect_to(dashboard_path), 'ダッシュボードにリダイレクトされていません'
    end
  end
end
