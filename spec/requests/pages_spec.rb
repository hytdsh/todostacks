require 'rails_helper'

RSpec.describe "Pages", type: :request do
  it "認証が何もないと / へのアクセスが 302 でリダイレクトされる" do
    get root_path
    expect(response).to have_http_status(302)
    expect(response).to redirect_to new_user_session_path
  end

  it "GoogleのOAuth認証を通過していれば / へのアクセスが 200 で応答する" do
    # このテストは system spec に書くべきか？
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
