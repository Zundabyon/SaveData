require 'rails_helper'

RSpec.describe 'dashboards/show', type: :view do
  let(:user) { create(:user) }

  before do
    assign(:user, user)
    assign(:games, [])
    allow(view).to receive(:current_user).and_return(user)
    render
  end

  it 'ユーザー名が表示されること' do
    expect(rendered).to include(user.name), 'ユーザー名がダッシュボードに表示されていません'
  end

  it '"冒険の記録"が表示されること' do
    expect(rendered).to include('冒険の記録'), '冒険の記録が表示されていません'
  end
end
