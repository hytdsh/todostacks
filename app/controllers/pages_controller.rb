class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:main]

  def main
  end

  def help
  end

  def contact
  end

  def about
  end
end
