class CollesController < ApplicationController
  include Documentable

  CATEGORY_FILTERS = { included: Category::PUBLIC_CATEGORIES }.freeze
end
