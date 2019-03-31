class ArticleRenderer < Redcarpet::Render::HTML
  include Rails.application.routes.url_helpers

  def paragraph(text)
    process_custom_tags("<p>#{text.strip}</p>\n")
  end

  private

  # document tag:
  # [document 123]{optional label}
  def process_custom_tags(html)
    html.gsub(/\[document\s(?<doc_id>\d*)\](\{(?<label>.*)\})?/) do |match|
      document_link($~[:doc_id], $~[:label])
    end
  end

  def document_link(id, label)
    document = Document.find_by_id(id)

    return "<i>deleted document</i>" if document.nil?

    ActionController::Base.helpers.link_to(
      label.presence || document.file.filename.to_s,
      download_documents_path(id),
      only_path: true,
      target: "_blank"
    )
  end
end
