class SensitiveWordsController < ApplicationController
  layout 'home_layout'
  before_filter :verify_login

  def index
    @sensitive_words = SensitiveWord.scope_paginate(params).order('created_at DESC')
  end

  def new
    @sensitive_word = SensitiveWord.new
  end

  def create
    @sensitive_word = SensitiveWord.new(params[:sensitive_words].permit(:word))
    if @sensitive_word.save
      redirect_to sensitive_words_url
    else
      flash[:create_msg] = '创建失败'
      render :action=>:new
    end
  end

  def delete_record
    word = find_stword
    word.destroy

    redirect_to :back
  end

  private
  def find_stword
    SensitiveWord.find(params[:id]) if params[:id].present?
  end
end