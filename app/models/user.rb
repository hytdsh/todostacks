class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :validatable
  devise :omniauthable, :omniauth_providers => [:google_oauth2]

  def self.from_omniauth(auth)
    # Either create a User record or update it based on the provider (Google) and the UID
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.token = auth.credentials.token
      user.expires = auth.credentials.expires
      user.expires_at = auth.credentials.expires_at
      user.refresh_token = auth.credentials.refresh_token
    end
  end

  def refresh_access_token_if_expired!
    if expires_at < Time.now.to_i
      oauth_with_google_urls = OmniAuth::Strategies::GoogleOauth2.new(
        nil,
        Rails.application.credentials.google[:client_id],
        Rails.application.credentials.google[:client_secret]
      )
      oauth_access_token = OAuth2::AccessToken.new(
        oauth_with_google_urls.client,
        token,
        refresh_token: refresh_token,
        expires_at: expires_at
      )
      new_oauth_access_token = oauth_access_token.refresh!
      update_attribute(:token, new_oauth_access_token.token)
      update_attribute(:expires_at, new_oauth_access_token.expires_at)
    end
  end
end
