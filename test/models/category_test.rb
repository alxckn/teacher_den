# == Schema Information
#
# Table name: categories
#
#  id               :integer          not null, primary key
#  label            :string
#  displayable_name :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
