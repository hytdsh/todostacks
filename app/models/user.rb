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
    oauth_include_google_urls = OmniAuth::Strategies::GoogleOauth2.new(
      nil,
      Rails.application.credentials.google[:client_id],
      Rails.application.credentials.google[:client_secret]
    )
    oauth_access_token = OAuth2::AccessToken.new(
      oauth_include_google_urls.client,
      token,
      refresh_token: refresh_token,
      expires_at: expires_at
    )
    new_oauth_access_token = oauth_access_token.refresh! if oauth_access_token.expired?
    self.token = new_oauth_access_token.token
    self.expires_at = oauth_access_token.expires_at
    self.save
  end
end
