module Documentable
  extend ActiveSupport::Concern

  included do

    def index
      documents
    end

    private

    def documents
      @documents ||= begin
        query = Document.includes(:category).joins(:category).with_attached_file

        if included_cats = self.class::CATEGORY_FILTERS.dig(:included)
          query = query.where(categories: { label: included_cats })
        elsif excluded_cats = self.class::CATEGORY_FILTERS.dig(:excluded)
          query = query.where.not(categories: { label: excluded_cats })
        end

        query
      end
    end
  end

end
