class ProductsController < ApplicationController
  layout 'home_layout'
  before_filter :verify_login
  before_action :find_element, :only=>[:show,:edit,:update,:delete_record]

  def index
    @products = Product.scope_paginate(params).order('created_at DESC')
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(params[:product].permit!)
    if @product.save
      flash[:success_msg] = '创建成功'
      redirect_to :back
    else
      render :action=>:new
    end

  end

  def show
    @product = find_element
  end

  def edit
    @product = find_element
  end

  def update
    @product = find_element
    result = @product.update_attributes(params[:product].permit!)
    if result
      flash[:success_msg] = '修改成功'
      redirect_to :back
    else
      render :action=>:edit
    end
  end

  def batch_update
    products = Product.where('id in (?)', params[:ids])
    products.each do |pro|
      pro.update_attributes({:state=>params[:state]})
    end

    redirect_to :back
  end

  def delete_record
    product = find_content
    product.state = PublicConstant::ST_DELETE
    product.save

    redirect_to :back
  end

  private
  def find_element
    Product.find(params[:id]) if params[:id].present?
  end
end