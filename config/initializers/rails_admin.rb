require Rails.root.join('lib', 'rails_admin_invite.rb')

RailsAdmin.config do |config|

  module RailsAdmin
    module Config
      module Actions
        class Invite < RailsAdmin::Config::Actions::Base
          RailsAdmin::Config::Actions.register(self)
        end
      end
    end
  end

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    resource = warden.authenticate! scope: :user
    resource if resource.admin?
    nil
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show

    invite
  end

  config.model "Document" do
    list do
      field :category do
        pretty_value do
          path = bindings[:view].show_path(model_name: "Category", id: value.id)
          bindings[:view].content_tag(:a, value.displayable_name.titleize, href: path)
        end
      end
      # field :file, :active_storage
      field :file, :active_storage do
        pretty_value do
          path = Rails.application.routes.url_helpers.rails_blob_path(value, only_path: true)
          bindings[:view].content_tag(
            :a,
            value.filename.to_s,
            href: path,
            target: "_blank"
          )
        end
      end

      field :note
      field :downloads_count
      field :last_downloaded_at
    end

    edit do
      field :category
      field :file, :active_storage
      field :note
    end
  end

  config.model "Category" do
    edit do
      fields :label, :displayable_name
    end
  end

  config.model "User" do
    edit do
      fields :email, :password, :admin
    end
  end
end
