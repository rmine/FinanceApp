class NewsController < ApplicationController
  layout 'home_layout'
  before_filter :verify_login
  before_action :find_element, :only=>[:show,:edit,:update,:delete_record]

  def index
    @news = News.scope_paginate(params).order('created_at DESC')
  end

  def new
    @news = News.new
    @news_finance_organizations = [@news.news_finance_organizations.build]*5
  end

  def create
    @news = News.new(params[:news].permit!)
    if @news.save
      flash[:success_msg] = '创建成功'
      redirect_to :back
    else
      @news_finance_organizations = @news.news_finance_organizations
      render :action=>:new
    end

  end

  def show
    @news = find_element
  end

  def edit
    @news = find_element
    @news_finance_organizations = @news.news_finance_organizations
  end

  def update
    @news = find_element
    result = @news.update_attributes(params[:news].permit!)
    if result
      flash[:success_msg] = '修改成功'
      redirect_to :back
    else
      @news_finance_organizations = @news.news_finance_organizations
      render :action=>:edit
    end
  end

  def batch_update
    news = News.where('id in (?)', params[:ids])
    news.each do |news|
      news.update_attributes({:state=>params[:state]})
    end

    redirect_to :back
  end

  def delete_record
    news = find_element
    news.state = PublicConstant::ST_DELETE
    news.save

    redirect_to :back
  end

  private
  def find_element
    News.find(params[:id]) if params[:id].present?
  end
end