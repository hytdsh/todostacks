class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:main]
  before_action :check_access_token, only: [:main]
  before_action :check_signet, only: [:main]

  def main
    service = connect_google_tasks
    @response = service.list_tasklists # max_results: 10 というような指定もできる
  end

  def help
  end

  def contact
  end

  def about
  end
end
