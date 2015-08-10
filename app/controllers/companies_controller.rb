class CompaniesController < ApplicationController
  layout 'home_layout'
  before_filter :verify_login
  before_action :find_element, :only=>[:show,:edit,:update,:delete_record]

  def index
    @companies = Company.scope_paginate(params).order('created_at DESC')
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(params[:company].permit!)
    if @company.save
      flash[:success_msg] = '创建成功'
      redirect_to :back
    else
      render :action=>:new
    end

  end

  def show
    @company = find_element
  end

  def edit
    @company = find_element
  end

  def update
    @company = find_element
    result = @company.update_attributes(params[:company].permit!)
    if result
      flash[:success_msg] = '修改成功'
      redirect_to :back
    else
      render :action=>:edit
    end
  end

  def batch_update
    companies = Company.where('id in (?)', params[:ids])
    companies.each do |content|
      content.update_attributes({:state=>params[:state]})
    end

    redirect_to :back
  end

  def delete_record
    company = find_element
    company.state = PublicConstant::ST_DELETE
    company.save

    redirect_to :back
  end

  private
  def find_element
    Company.find(params[:id]) if params[:id].present?
  end
end