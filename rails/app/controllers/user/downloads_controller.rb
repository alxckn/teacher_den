class User::DownloadsController < User::UserController
  include Documentable

  CATEGORY_FILTERS = { excluded: Category::PUBLIC_CATEGORIES }.freeze

  def index
    documents
  end
end
