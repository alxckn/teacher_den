class ApplicationController < ActionController::Base
  helper_method :gv
  before_action :global_vars
  # https://stackoverflow.com/questions/43356105/actioncontrollerinvalidauthenticitytoken-rails-5-devise-audited-papertra/46268057
  protect_from_forgery prepend: true

  private

  def gv(key)
    global_vars.find { |g| g.key == key }&.value
  end

  def global_vars
    @global_vars ||= GlobalVar.all
  end

  def markdown
    @markdown ||= Redcarpet::Markdown.new(ArticleRenderer, autolink: true, tables: true)
  end
end
