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
require "test_helper"

class GameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
