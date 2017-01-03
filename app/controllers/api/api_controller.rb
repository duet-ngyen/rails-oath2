class Api::ApiController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Api::RespondersHelper

end