class User::InformationsController < User::UserController
  def index
    articles
    markdown
  end

  private

  def articles
    @articles ||= Article.published.where(parent_id: nil).where(private: true)
  end
end
