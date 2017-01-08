class Api::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  Swagger::Docs::Generator::set_real_methods
  before_action :set_default_response_format
  include Api::RespondersHelper
  respond_to :json
  swagger_controller :OmniauthCallbacks, "OmniauthCallbacks"

  swagger_api :omniauth_success do |api|
    summary "Create a new User with face book"
    param :query, :access_token, :string, :require, 'access_token'
    param :query, :expires_in, :integer, :require, "expires_in"
    param :path, :provider, :string, :require, "[facebook]"

    response :unauthorized
    response :not_acceptable
    response :unprocessable_entity
  end

  def omniauth_success
    begin
      provider = params[:provider]
      case provider
        when 'facebook'
          get_resource_from_facebook(params[:access_token],params[:expires_in])
        when 'google_oauth2'
          get_resource_from_google(params[:access_token])
        else
          "You gave me -- I have no idea what to do with that."
      end
      if @resource.present?
        create_token_info
        set_token_on_resource
        create_auth_params
        sign_in(:user, @resource, store: false, bypass: false)

        @resource.save!
        update_auth_header

        yield @resource if block_given?

        respond_with @resource
      else
        respond_error "Token invaild"
      end

    rescue Exception => e
      respond_error hash_exception(e)
    end

  end

  protected
  def get_resource_from_facebook(access_token, expires_in)
    graph = Koala::Facebook::API.new(access_token)
    profile = graph.get_object('me?fields=email,name,id,picture')
    @resource = User.where({
                               uid:      profile['id'],
                               provider: 'facebook'
                           }).first_or_initialize do |user|
      user.provider = 'facebook'
      user.uid = profile['id']
      user.name = profile['name']
      user.oauth_token = access_token
      user.password = Devise.friendly_token[0,20]
      user.image_url = profile['picture']["data"]["url"] if profile['picture'].present?
      user.oauth_expires_at = Time.at(expires_in.to_i)
      user.skip_confirmation!
      user.save!
    end

    if @resource.new_record?
      @oauth_registration = true
      set_random_password
    end
    @resource
  end

  def get_resource_from_google(token)
    response = HTTParty.get("https://www.googleapis.com/oauth2/v2/userinfo",
                            headers: {"Access_token"  => token,
                                      "Authorization" => "OAuth #{token}"})
    if response.code == 200
      data = JSON.parse(response.body)
      @resource = User.where({uid:data['id'],provider: 'google_oauth2'}).first_or_initialize
      @resource.uid = data['id']
      @resource.name = data['name']
      @resource.oauth_token = token
      @resource.password = Devise.friendly_token[0,20]
      @resource.image_url = data['picture'] if data['picture'].present?
      # user.oauth_expires_at = Time.at(expires_in.to_i)
      @resource.skip_confirmation!
      @resource.save!
      if @resource.new_record?
        @oauth_registration = true
        set_random_password
      end

      @resource
    end
    response.code

  end

  def get_resource_from_twitter(access_token, expires_in)

  end

  def set_default_response_format
    request.format = :json
  end
end