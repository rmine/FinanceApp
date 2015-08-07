class CategoriesController < ApplicationController
  layout 'home_layout'
  before_filter :verify_login
  before_action :find_element, :only=>[:show,:edit,:update,:delete_record]

  def index
    @categories = Category.scope_paginate(params).order('created_at DESC')
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params[:category].permit!)
    if @category.save
      flash[:error_msg] = '创建成功'
    else
      flash[:error_msg] = '创建失败'
    end

    redirect_to :back

  end

  def show
    @category = find_element
  end

  def edit
    @category = find_element
  end

  def update
    @category = find_element
    result = @category.update_attributes(params[:category].permit!)
    if result
      flash[:error_msg] = '修改成功'
      redirect_to :back
    else
      flash[:error_msg] = '修改失败'
      render :action=>:edit
    end
  end

  def batch_update
    categories = Category.where('id in (?)', params[:ids])
    categories.each do |content|
      content.update_attributes({:state=>params[:state]})
    end

    redirect_to :back
  end

  def delete_record
    category = find_element
    category.state = PublicConstant::ST_DELETE
    category.save

    redirect_to :back
  end

  private
  def find_element
    Category.find(params[:id]) if params[:id].present?
  end
end