class Collect < ActiveRecord::Base
  belongs_to :content
  belongs_to :user

  # attr_accessible :user_id,
  #                 :content_id

  scope :info_by_user_content, proc {|user_id, content_id| where('collects.user_id = ? and collects.content_id = ?', user_id, content_id)}

  scope :by_content_id, proc {|content_id| where('collects.content_id=?', content_id)}

  scope :by_user, proc {|user_id| where('collects.user_id=?', user_id)}

  scope :order_created_desc, ->{order('collects.created_at desc')}

  def self.is_collect(content_id, user_id)
    where('collects.content_id = ? and collects.user_id = ?', content_id, user_id).count(:id) > 0 ? 1 : 0
  end

  def self.create_with_params(params)
    Collect.create({:user_id=>params[:user_id], :content_id=>params[:content_id]})
  end

end
