class Feedback < ActiveRecord::Base
  belongs_to :user

  # attr_accessible :user_id,
  #                 :suggest,
  #                 :contact

  def self.create_with_params(params)
    Feedback.create(params)
  end

  def self.scope_paginate(params)
    self.paginate(:page => params[:page], :per_page => 20)
  end
end