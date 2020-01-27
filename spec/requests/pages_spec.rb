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
      # ここでは post user_google_oauth2_omniauth_authorize_url に対する
      # レスポンスとして set_omniauth でモックされた「Google側の応答」が発生している。
      # (byebug) response.body
      # "Redirecting to http://www.example.com/users/auth/google_oauth2/callback..."
      byebug

      follow_redirect!

      # ここでは controllers/users/omniauth_callbacks_controller.rb の Users::OmniauthCallbacksController#google_oauth2
      # で redirect_to '/' しているのが反映されている。
      # (byebug) response.body
      # "<html><body>You are being <a href=\"http://www.example.com/\">redirected</a>.</body></html>"
      byebug

      follow_redirect!


      # ここでは controllers/application_controller.rb の ApplicationController#connect_google_tasks で
      # signet_oauth_client.fetch_access_token に失敗するために sign_out へのリダイレクトが発生している。
      # (byebug) response.body
      # "<html><body>You are being <a href=\"http://www.example.com/sign_out\">redirected</a>.</body></html>"
      byebug

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
