module Documentable
  extend ActiveSupport::Concern

  included do

    def index
      documents
    end

    def download
      # Check download is enabled
      # Checking the user is connected is done beforehand by the controller
      category = document.category
      if (self.class::CATEGORY_FILTERS.dig(:included) && !self.class::CATEGORY_FILTERS.dig(:included).include?(category.label)) ||
         (self.class::CATEGORY_FILTERS.dig(:excluded) && self.class::CATEGORY_FILTERS.dig(:excluded).include?(category.label))
        raise "This document download is not permitted"
      end

      document.with_lock do
        document.downloads_count += 1
        document.last_downloaded_at = Time.now.utc
        document.save!
      end

      redirect_to rails_blob_path(document.file)
    end

    private

    def document
      @document ||= Document.includes(:category).find params[:download_id]
    end

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
