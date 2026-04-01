require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  let(:user) { create(:user) }

  before do
    assign(:user, user)
    assign(:games, [])
    assign(:favorite_genre, nil)
    render
  end

  it '冒険者免許証が表示されること' do
    expect(rendered).to include('冒険者免許証'), '冒険者免許証が表示されていません'
  end

  it 'ユーザー名が表示されること' do
    expect(rendered).to include(user.name), 'ユーザー名が表示されていません'
  end
end
