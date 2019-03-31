class User::DownloadsController < User::UserController
  include Documentable

  CATEGORY_FILTERS = { excluded: ["colles"] }.freeze

  def index
    documents
  end
end
