require 'rails_helper'

RSpec.describe "Pages", type: :request do
  it "認証が何もないと '/' へのアクセスが 302 でリダイレクトされる" do
    get root_path
    expect(response).to have_http_status(302)
    expect(response).to redirect_to new_user_session_path
  end

  context "OmniAuth" do
    before do
      set_omniauth
      # it seems to work without Rails.application.env_config[].
#      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
#      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]

      # change(User, :count).by(1) の次のステップで使う ApplicationController#connect_google_tasks をモックしている
      allow_any_instance_of(ApplicationController).to receive(:connect_google_tasks).and_return(true)
    end
    subject do
      # 「Google側」に post を送信する
      post user_google_oauth2_omniauth_authorize_url
      # set_omniauth でモックされた「Google側の応答」がコールバックへのリダイレクトになっているので follow_redirect! が必要
      follow_redirect!
    end
    it "GoogleのOAuth認証を通過すると User の count が 1 増えて、'/' へのアクセスが 200 になる" do
      # コールバック Users::OmniauthCallbacksController の中で User が新規登録され count が1増える
      expect{ subject }.to change(User, :count).by(1)

      # コールバックで「ユーザー登録 change(User, :count).by(1)」した次のステップとして '/' へのリダイレクトが
      # 発生しているので follow_redirect! が必要
      follow_redirect!
      # follow_redirect! で '/' に遷移する際に before_action で指定している　ApplicationController#connect_google_tasks
      # についてはモックが機能して通過できるが、インスタンス変数を適切に構成できず（渡せず） PagesController#main の中でエラーとなる

      # PagesController#main の中でエラーが発生するため、現時点では fail する
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
