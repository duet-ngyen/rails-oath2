# require 'active_support/concern'
module Api
  module RespondersHelper
    extend ActiveSupport::Concern

    def respond_without_location(resource, status = nil)
      if status.present?
        respond_with resource, status: status, location: nil
      else
        respond_with resource, location: nil
      end
    end

    def respond_error(errors=[], status=400)
      res = {
          success: false,
          errors: errors
      }
      # respond_with res, status: status, location: nil
      render json: res, status: status, location: nil
    end

    def respond_success(message = '', status = 200)
      res = {
          success: true,
          message: message
      }
      # respond_with res, status: status, location: nil
      render json: res, status: status, location: nil
    end

    def hash_exception(e)
      {
          exception_detail: e.backtrace,
          full_messages: [
              e.message
          ]
      }
    end
  end
end