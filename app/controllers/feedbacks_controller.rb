class FeedbacksController < ApplicationController
  layout 'home_layout'
  before_filter :verify_login

  def index
    @feedbacks = Feedback.scope_paginate(params).order('created_at DESC')
  end


end