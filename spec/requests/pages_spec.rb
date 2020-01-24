require 'rails_helper'

RSpec.describe "Pages", type: :request do
  it "認証が何もないと / へのアクセスが 302 でリダイレクトされる" do
    get root_path
    expect(response).to have_http_status(302)
    expect(response).to redirect_to new_user_session_path
  end

  context "OmniAuth" do
    before do
      set_omniauth
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
      post user_google_oauth2_omniauth_authorize_url
    end
    it "GoogleのOAuth認証を通過していれば / へのアクセスが 200 で応答する" do
      get root_url
      expect(response).to have_http_status(200)
    end
  end

  it "GET /help" do
    get help_path
    expect(response).to have_http_status(200)
  end

  it "GET /contact" do
    get contact_path
    expect(response).to have_http_status(200)
  end

  it "GET /about" do
    get about_path
    expect(response).to have_http_status(200)
  end
end
