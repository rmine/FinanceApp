class ContentComment < ActiveRecord::Base
  belongs_to :content
  belongs_to :user

  # attr_accessible :content_id,
  #                 :user_id,
  #                 :comment

  scope :info_by_user_content, proc {|user_id, content_id| where('content_comments.user_id = ? and content_comments.content_id = ?', user_id, content_id)}

  scope :by_time, proc {|time| where('content_comments.created_at <= ?', time) if time.present?}

  scope :by_content_id, proc {|content_id| where('content_comments.content_id=?', content_id)}

  scope :order_created_asc, ->{order('content_comments.created_at asc')}

  def self.create_with_params(params)
    ContentComment.create({:user_id=>params[:user_id],:content_id=>params[:content_id],:comment=>params[:comment]})
  end
end