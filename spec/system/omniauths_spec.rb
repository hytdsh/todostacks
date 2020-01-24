#require 'rails_helper'
#
#RSpec.describe "Omniauths", type: :system do
#  before do
#    driven_by(:rack_test)
#  end
#
#  context "OmniAuth" do
#    before do
#      set_omniauth
#      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
#      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
#      get user_google_oauth2_omniauth_authorize_url
#    end
#    it "GoogleのOAuth認証を通過していれば / へのアクセスが 200 で応答する" do
#      expect(response).to have_http_status(200)
#    end
#  end
#end
