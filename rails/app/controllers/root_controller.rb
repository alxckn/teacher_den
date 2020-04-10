class RootController < ApplicationController
  def show
    articles
    markdown
  end

  private

  def articles
    @articles ||= Article.published.where(parent_id: nil).where(private: false)
  end
end
