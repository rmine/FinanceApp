class NewsController < ApplicationController
  layout 'home_layout'
  before_action :find_element, :only=>[:show,:edit,:update,:delete_record]

  def index
    @news = News.scope_paginate(params).order('created_at DESC')
  end

  def new
    @content = Content.new
  end

  def create
    @content = Content.new(params[:contents].permit!)
    if @content.save
      # redirect_to contents_url
      flash[:error_msg] = '创建成功'
    else
      flash[:error_msg] = '创建失败'
    end

    redirect_to :back

  end

  def show
    @news = find_news
  end

  def edit
    @news = find_content
  end

  def update
    @content = find_content
    result = @content.update_attributes(params[:contents].permit!)
    if result
      redirect_to :back
    else
      flash[:create_msg] = '修改失败'
      render :action=>:edit
    end
  end

  def batch_update
    contents = Content.where('id in (?)', params[:ids])
    contents.each do |content|
      content.update_attributes({:state=>params[:state]})
    end

    redirect_to :back
  end

  def delete_record
    content = find_content
    content.state = Content::ST_DELETE
    content.save

    redirect_to :back
  end

  private
  def find_element
    News.find(params[:id]) if params[:id].present?
  end
end