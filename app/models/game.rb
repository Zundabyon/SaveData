# == Schema Information
#
# Table name: games
#
#  id          :bigint           not null, primary key
#  difficulty  :integer
#  ended_year  :integer
#  fun         :integer
#  hardware    :string
#  memo        :text
#  reccomended :string
#  title       :string
#  type        :string
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
end
# GameモデルとUserモデルの関連付けを行っています。
# 各ゲームは1人のユーザーに属している（多対1の関係）
# ことを示しています。
# belongs_to :user は、Gameモデルが
# Userモデルに属していることを示し、
# 各ゲームが特定のユーザーに関連付けられていることを意味します。
