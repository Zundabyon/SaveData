require 'rails_helper'

RSpec.describe 'games/edit', type: :view do
  let(:game) { create(:game) }

  before do
    assign(:game, game)
    render
  end

  it '"EDIT DATA"の見出しが表示されること' do
    expect(rendered).to include('EDIT DATA'), '"EDIT DATA"の見出しが表示されていません'
  end

  it 'SAVEボタンが表示されること' do
    expect(rendered).to include('SAVE'), 'SAVEボタンが表示されていません'
  end
end
