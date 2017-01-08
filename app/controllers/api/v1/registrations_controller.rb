class Api::V1::RegistrationsController < DeviseTokenAuth::RegistrationsController
  include Api::RespondersHelper
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_default_response_format, if: :devise_controller?
  respond_to :json
  Swagger::Docs::Generator::set_real_methods

  swagger_controller :registrations, "RegistrationsController"

  swagger_api :create do |api|
    summary "Create a new User item"
    param :form, :email, :string, :require, 'email'
    param :form, :password, :string, :require, "password"
    param :form, :password_confirmation, :string, :require, "password"
    param :form, :profile_picture, :byte, :require, "Base 64 image"

    response :unauthorized
    response :not_acceptable
    response :unprocessable_entity
  end

  def create
    begin
      super
    rescue StandardError => e
      respond_error hash_exception(e)
    end

  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email,:password, :profile_picture])
  end

  def set_default_response_format
    request.format = :json
  end
end

