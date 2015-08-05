class SessionsController < ApplicationController
  before_filter :session_url, :only=>[:create]

  def index
    render :action=>:new
  end

  def new
    @admin_user = AdminUser.new
  end

  def create
    admin_user = AdminUser.find_by_username(params[:username])
    if admin_user && admin_user.authenticate(params[:password])
      session[:user_id] = admin_user.id
      redirect_to session[:url_back], :notice => "Logged in!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def logout
    session[:user_id] = nil
    session[:url_back] = nil
    render :action=>:new
  end
end
