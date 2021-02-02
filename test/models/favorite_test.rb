# == Schema Information
#
# Table name: favorites
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parking_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_favorites_on_parking_id              (parking_id)
#  index_favorites_on_user_id                 (user_id)
#  index_favorites_on_user_id_and_parking_id  (user_id,parking_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (parking_id => parkings.id)
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class FavoriteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
