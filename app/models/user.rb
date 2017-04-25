class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  include DeviseTokenAuth::Concerns::User
  attachment :profile_picture

  def profile_picture= value
    __send__("profile_picture_id_will_change!")
    super(StringIO.new(Base64.decode64(value)))
  end
end
