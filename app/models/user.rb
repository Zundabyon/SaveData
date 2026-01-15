# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  birthday         :date
#  crypted_password :integer
#  email            :string
#  gender           :boolean
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class User < ApplicationRecord
end
