class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #      :recoverable, :rememberable, :trackable, :validatable
  
  # copied from https://www.digitalocean.com/community/tutorials/how-to-configure-devise-and-omniauth-for-your-rails-application
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
     :omniauthable, :omniauth_providers => [:google_oauth2]

  def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
      end
  end

  # for omniauth
  devise :omniauthable, :omniauth_providers => [:google_oauth2]

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
         user = User.create(name: data["name"],
            email: data["email"],
            password: Devise.friendly_token[0,20]
         )
    end
    user
end

end