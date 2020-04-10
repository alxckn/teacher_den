class Api::V1::DocumentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate

  def create
    document = Document.new(documents_params)
    if document.save
      render json: {}, status: 200
    else
      render json: { errors: document.errors }, status: 422
    end
  end

  private

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      resource = User.find_by_email(username)
      if resource && resource.admin? && resource.valid_password?(password)
        sign_in :admin, resource
      end
    end
  end

  def documents_params
    params.require(:document).permit(:category_label, :category_id, :file)
  end
end
