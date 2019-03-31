class CollesController < ApplicationController
  include Documentable

  CATEGORY_FILTERS = { included: ["colles"] }.freeze
end
