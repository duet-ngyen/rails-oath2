class Api::ApiController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Api::RespondersHelper
  Swagger::Docs::Generator::set_real_methods

end