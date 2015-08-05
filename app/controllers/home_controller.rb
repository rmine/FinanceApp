class HomeController < ApplicationController
  before_filter :verify_login

  def index
  end

end