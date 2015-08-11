# coding: utf-8
class ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token,:only=>[:finance_news_list, :finance_info]
  before_filter :find_content, :only => [:collect_content, :uncollect_content, :submit_comment]

	def index
    render :text=>'There is nothing!'
  end

  # #客户端启动就调用
  # def register_user
  #   if params[:idfa].blank?
  #     @result_code = 0
  #     @result_msg = '参数异常'
  #   else
  #     @result_code = 2
  #     @result_msg = '用户名已经存在'
  #     @user = User.where('idfa = ?', params[:idfa]).first
  #     if @user.blank?
  #       @user = User.create(:idfa=>params[:idfa],:nick=>'游客'+rand_str(12))
  #       @result_code = 1
  #       @result_msg = '注册成功'
  #     end
  #
  #   end
  #   render 'register_user.json.jbuilder'
  # end
  #
  # #用户注册接口,以oauth_type和uid字段判断是否是第三方接入
  # def register
  #   @result_code = 0
  #   if params[:oauth_type].blank? || params[:uid].blank?
  #     #普通注册用户分支,判断用户名和密码
  #     if params[:username].blank? or params[:password].blank?
  #       @result_msg = '参数异常'
  #     else
  #       @user = User.where('username = ?', params[:username]).first
  #       if @user.present?
  #         @result_msg = '用户名已经存在'
  #       else
  #         @user = User.create_with_params(params.permit(:username,:password,:nick,:avatar,:email,:idfa,:oauth_type,:uid,:created_at,:updated_at))
  #         if @user.save
  #           @result_code = 1
  #           @result_msg = '注册成功'
  #         else
  #           @result_msg = @user.errors.messages
  #         end
  #       end
  #     end
  #
  #   else
  #     @user = User.where('uid = ? and oauth_type = ? ', params[:uid], params[:oauth_type]).first
  #     if @user.present?
  #       if params[:avatar].present?
  #         @user.avatar = params[:avatar]
  #         @user.save
  #       end
  #       @result_code = 2
  #       @result_msg = '用户已经授权,信息已经更新'
  #     else
  #       @user = User.create_with_params(params.permit(:username,:password,:nick,:avatar,:email,:idfa,:oauth_type,:uid,:created_at,:updated_at))
  #       if @user.save
  #         @result_code = 1
  #         @result_msg = '注册成功'
  #       else
  #         @result_msg = @user.errors.messages
  #       end
  #     end
  #
  #   end
  #
  #   render 'register.json.jbuilder'
  # end
  #
  # def login
  #   @result_code = 0
  #   if params[:username].blank? or params[:password].blank?
  #     @result_msg = '参数异常'
  #   else
  #     if User.auth(params[:username], params[:password])
  #       @result_code = 1
  #       @result_msg = '登陆成功'
  #       @user = User.where('username=?',params[:username]).first
  #     else
  #       @result_msg = '用户名和密码不匹配'
  #     end
  #   end
  #   render 'login.json.jbuilder'
  # end
  #
  # #此接口适用于普通注册用户，第三方不支持
  # def update_password
  #   @result_code = 0
  #   if params[:username].blank? or params[:password].blank? or params[:new_password].blank?
  #     @result_msg = '参数异常'
  #   else
  #     if User.auth(params[:username], params[:password])
  #       user = User.where('username=?',params[:username]).first
  #       if User.update_with_params(user, params.permit(:username,:password,:nick,:avatar,:email,:idfa,:oauth_type,:uid,:created_at,:updated_at).merge!({:password=>Digest::MD5.hexdigest(params[:new_password])}))
  #         @result_code = 1
  #         @result_msg = '修改成功'
  #       else
  #         @result_msg = user.errors.messages
  #       end
  #     else
  #       @result_msg = '用户名和密码不匹配'
  #     end
  #   end
  #   render 'common.json.jbuilder'
  # end
  #
  # #"我的经历"功能
  # def my_journey
  #   @result_code = 0
  #   @result_msg = '参数异常'
  #   user = User.info(params[:user_id]).first
  #   if user.present?
  #     @result_code = 1
  #     @result_msg = '获取成功'
  #
  #     @collect_num = user.collects.count
  #     @comment_num = user.comments.count
  #     @praise_num = user.praises.count
  #   end
  #   render 'my_journey.json.jbuilder'
  # end
  #
  # #获取笑话等数据
  # #type： 0 joke 1 pics 2 article  3news
  # def contents_list
  #   @contents = Content.valid.type_of(params[:type]).by_time(params[:time]).limit(30).order_created_desc
  #   render 'contents_list.json.jbuilder'
  # end
  #
  # #获取某记录的评论
  # def content_comments_list
  #   offset = params[:offset].blank? ? 0:params[:offset]
  #   @comments = ContentComment.by_content_id(params[:content_id]).offset(offset).limit(10).order_created_asc
  #   @left_amount = ContentComment.by_content_id(params[:content_id]).count - (offset.to_i+@comments.count)
  #   render 'content_comments_list.json.jbuilder'
  # end
  #
  # #获取60条精华内容,按点赞数倒序排列
  # #day week month
  # def contents_essence_list
  #   time_format = params[:time_format].blank? ? 'month' : params[:time_format]
  #   datetime = get_essence_time(time_format)
  #   @contents = Content.valid.essence_by_time(datetime).limit(60).order('praise_num desc')
  #   render 'contents_essence_list.json.jbuilder'
  # end
  #
  # #穿越60条
  # def contents_cross_list
  #   @datetime = Content.rand_time(rand(1..15).days.ago)
  #   @contents = Content.valid.by_time(@datetime).limit(60).order('created_at desc')
  #   render 'contents_cross_list.json.jbuilder'
  # end
  #
  # #我的收藏列表
  # def my_collects_list
  #   @collects = Collect.by_user(params[:user_id]).order_created_desc
  #   render 'my_collects_list.json.jbuilder'
  # end
  #
  # #收藏
  # def collect_content
  #   @result_code = 0
  #   @result_msg = '参数异常'
  #   if User.info(params[:user_id]).present? && find_content.present?
  #     if Collect.info_by_user_content(params[:user_id], params[:content_id]).blank?
  #       if Collect.create_with_params(params)
  #         @result_code = 1
  #         @result_msg = '收藏成功'
  #       else
  #         @result_msg = '服务器错误'
  #       end
  #     else
  #       @result_msg = '不能重复收藏'
  #     end
  #   end
  #
  #   render 'collect_content.json.jbuilder'
  # end
  #
  # #取消收藏
  # def uncollect_content
  #   @result_code = 0
  #   @result_msg = '参数异常'
  #   if User.info(params[:user_id]).present? && find_content.present?
  #     collect = Collect.info_by_user_content(params[:user_id], params[:content_id])
  #     if collect.present?
  #       collect.destroy_all
  #       @result_code = 1
  #       @result_msg = '取消收藏成功'
  #     else
  #       @result_msg = '不能对未收藏的记录进行取消操作'
  #     end
  #   end
  #
  #   render 'collect_content.json.jbuilder'
  # end
  #
  # #点赞
  # def praise_content
  #   @result_code = 0
  #   @result_msg = '参数异常'
  #   if User.info(params[:user_id]).present? && find_content.present?
  #     if Praise.info_by_user_content(params[:user_id], params[:content_id]).blank?
  #       if Praise.create_with_params(params) && find_content.increment!(:praise_num, 1)
  #         @result_code = 1
  #         @result_msg = '点赞成功'
  #       else
  #         @result_msg = '服务器错误'
  #       end
  #     else
  #       @result_msg = '不能重复点赞'
  #     end
  #   end
  #
  #   render 'collect_content.json.jbuilder'
  # end
  #
  # #提交评论
  # def submit_comment
  #   @result_code = 0
  #   @result_msg = '参数异常'
  #   if User.info(params[:user_id]).present? && find_content.present? && params[:comment].present?
  #     if ContentComment.create_with_params(params.permit(:content_id,:user_id,:comment)) && find_content.increment!(:comment_num, 1)
  #       @result_code = 1
  #       @result_msg = '评论成功'
  #     end
  #   end
  #
  #   render 'submit_comment.json.jbuilder'
  # end
  #
  # #用户反馈
  # def feedbacks
  #   @result_code = 0
  #   @result_msg = '参数异常'
  #   if User.info(params[:user_id]).present? && params[:suggest].present?
  #     if Feedback.create_with_params(params.permit(:user_id,:suggest,:contact))
  #       @result_code = 1
  #       @result_msg = '提交成功'
  #     end
  #   end
  #
  #   render 'submit_comment.json.jbuilder'
  # end
  #
  # def upload_avatar
  #   @result_code = 0
  #   @result_msg = '参数异常'
  #   if request.post? && User.info(params[:user_id]).present? && params[:avatar].present?
  #     avatar = params[:avatar]
  #     image_info = upload_image(avatar,"avatars")
  #     @avatar = qiniu_file(image_info)
  #     if @avatar.present?
  #       if find_user.update_attributes({:avatar=>@avatar})
  #         @result_code = 1
  #         @result_msg = '上传成功'
  #       end
  #     end
  #   end
  #
  #   render 'upload_avatar.json.jbuilder'
  # end


  ###########################
  def finance_news_list
    @page = params[:page].blank? ? 1 : params[:page]
    @page_size = params[:page_size].blank? ? 20 : params[:page_size]
    @news = News.approved.paginate(:page => @page, :per_page => @page_size).order_created_desc
    total_number = (News.approved.count.to_i/@page_size.to_i) == 0 ? 1 : (News.approved.count.to_i/@page_size.to_i)
    @left_page = total_number - @page.to_i
    render "finance_news_list.json.jbuilder"
  end

  def finance_info
    @result_code = 0
    @result_msg = '参数异常'
    if params[:news_id].present? && find_news.present?
      @news = find_news
      @finance_details = @news.product.news.order_finance_asc
      @result_code = 1
      @result_msg = '请求成功'
    end

    render "finance_info.json.jbuilder"
  end

  private
  def find_news
    News.where(id: params[:news_id], state: PublicConstant::ST_APPROVED).first if params[:news_id].present?
  end

  def find_content
    Content.find_by_id(params[:content_id])
  end

  def find_user
    User.find_by_id(params[:user_id])
  end

  def get_essence_time(time_format)
    if time_format == 'day'
      datetime = Date.today
    elsif time_format == 'week'
      datetime = Date.today.at_beginning_of_week
    else
      datetime = Date.today.at_beginning_of_month
    end
    datetime
  end


end
