# see http://www.emilsoman.com/blog/2013/05/18/building-a-tested/
class Api::V1::SessionsController < DeviseTokenAuth::SessionsController
  include Api::RespondersHelper
  Swagger::Docs::Generator::set_real_methods
  swagger_controller :sessions, "SessionController"

  swagger_api :create do |api|
    summary "Login use"
    param :form, :email, :string, :require, 'email'
    param :form, :password, :string, :require, "password"
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

end

