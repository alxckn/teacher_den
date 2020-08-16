# == Schema Information
#
# Table name: documents
#
#  id                 :integer          not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  file_file_name     :string
#  file_content_type  :string
#  file_file_size     :integer
#  file_updated_at    :datetime
#  token              :string
#  category_id        :integer
#  downloads_count    :integer          default(0)
#  last_downloaded_at :datetime
#  note               :text
#

require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
