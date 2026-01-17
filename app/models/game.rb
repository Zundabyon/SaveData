# == Schema Information
#
# Table name: games
#
#  id          :bigint           not null, primary key
#  difficulty  :integer
#  ended_year  :integer
#  fun         :integer
#  genre       :string
#  hardware    :string
#  memo        :text
#  played_age  :integer
#  played_year :integer
#  reccomended :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_games_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Game < ApplicationRecord
  belongs_to :user


  validates :title, presence: true
  validates :played_year, presence: true

end
# GameモデルとUserモデルの関連付けを行っています。
# 各ゲームは1人のユーザーに属している（多対1の関係）
# belongs_to :user は、Gameモデルがserモデルに属していることを示し、
# 各ゲームが特定のユーザーに関連付けられていることを意味します。
