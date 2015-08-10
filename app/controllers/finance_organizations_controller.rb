class FinanceOrganizationsController < ApplicationController
  layout 'home_layout'
  before_filter :verify_login
  before_action :find_element, :only=>[:show,:edit,:update,:delete_record]

  def index
    @finance_organizations = FinanceOrganization.scope_paginate(params).order('created_at DESC')
  end

  def new
    @finance_organization = FinanceOrganization.new
  end

  def create
    @finance_organization = FinanceOrganization.new(params[:finance_organization].permit!)
    if @finance_organization.save
      flash[:success_msg] = '创建成功'
      redirect_to :back
    else
      render :action=>:new
    end

  end

  def show
    @finance_organization = find_element
  end

  def edit
    @finance_organization = find_element
  end

  def update
    @finance_organization = find_element
    result = @finance_organization.update_attributes(params[:finance_organization].permit!)
    if result
      flash[:success_msg] = '修改成功'
      redirect_to :back
    else
      render :action=>:edit
    end
  end

  def batch_update
    finance_organizations = FinanceOrganization.where('id in (?)', params[:ids])
    finance_organizations.each do |content|
      content.update_attributes({:state=>params[:state]})
    end

    redirect_to :back
  end

  def delete_record
    finance_organization = find_element
    finance_organization.state = PublicConstant::ST_DELETE
    finance_organization.save

    redirect_to :back
  end

  private
  def find_element
    FinanceOrganization.find(params[:id]) if params[:id].present?
  end
end