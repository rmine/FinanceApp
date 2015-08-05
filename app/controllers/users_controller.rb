class UsersController < ApplicationController
  layout 'home_layout'
  before_filter :verify_login


  def index
    @users = User.scope_paginate(params).order('created_at DESC')
  end
end