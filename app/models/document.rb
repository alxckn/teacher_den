# == Schema Information
#
# Table name: documents
#
#  id                :integer          not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  file_file_name    :string
#  file_content_type :string
#  file_file_size    :integer
#  file_updated_at   :datetime
#  token             :string
#  category_id       :integer
#

class Document < ApplicationRecord
  attr_accessor :category_label

  default_scope { order(created_at: :desc) }

  belongs_to :category, class_name: "::Category",
                        inverse_of: :documents,
                        optional: false

  has_one_attached :file

  before_validation :set_category

  private

  def set_category
    if !category && category_label
      self.category = Category.find_by_label(category_label)
    end
  end
end
