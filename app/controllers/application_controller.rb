class ApplicationController < ActionController::Base

  private
    def refresh_access_token_if_expired!
      current_user.refresh_access_token_if_expired!
    end
end
