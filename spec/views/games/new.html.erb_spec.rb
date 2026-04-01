require 'rails_helper'

RSpec.describe 'games/new', type: :view do
  before do
    assign(:game, build(:game))
    render
  end

  it '"NEW DATA"の見出しが表示されること' do
    expect(rendered).to include('NEW DATA'), '"NEW DATA"の見出しが表示されていません'
  end

  it 'SAVEボタンが表示されること' do
    expect(rendered).to include('SAVE'), 'SAVEボタンが表示されていません'
  end
end
