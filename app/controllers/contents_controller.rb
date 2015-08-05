class ContentsController < ApplicationController
  layout 'home_layout'
  before_filter :verify_login, :except=>[:upload_pic, :test_qiniu]

  def index
    @contents = Content.scope_paginate(params).order('created_at DESC')
  end

  def test_qiniu
    put_policy = Qiniu::Auth::PutPolicy.new(
        'jokenewsworld',
    )

    #p uptoken = Qiniu::Auth.generate_uptoken(put_policy)

    #local_file = '/home/huangzhaorong/d01373f082025aaf4b5e4b6cfaedab64034f1a2c.jpg'
    local_file = '/Users/RMine/Downloads/metronic.bootstrap/metronic.bootstrap/media/image/1.jpg'
    key = 'test-001.jpg'
    p result = Qiniu::Storage.upload_with_put_policy(
         put_policy,     # 上传策略
         local_file,
         key
    )
    p result[0]
    p result[1]['key']

    render :text=>result
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
    @content = find_content
  end

  def edit
    @content = find_content
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


  def upload_pic
    if request.post?
      # filename = params[:Filename]
      pic = params[:Filedata]
      image_info = upload_image(pic,"contents")
      qiniu_url = qiniu_file(image_info)
      render :text=>qiniu_url
    end
  end

  private
  def find_content
    Content.find(params[:id]) if params[:id].present?
  end

end