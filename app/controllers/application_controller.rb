class ApplicationController < ActionController::Base
  def hello
    render html: "hello, TodoStacks!"
  end
end
