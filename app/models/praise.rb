class Praise < ActiveRecord::Base
  belongs_to :content
  belongs_to :user

  # attr_accessible :user_id,
  #                 :content_id

  scope :info_by_user_content, proc {|user_id, content_id| where('praises.user_id = ? and praises.content_id = ?', user_id, content_id)}

  def self.is_praise(content_id, user_id)
    where('praises.content_id = ? and praises.user_id = ?', content_id, user_id).count(:id) > 0 ? 1 : 0
  end

  def self.create_with_params(params)
    Praise.create({:user_id=>params[:user_id], :content_id=>params[:content_id]})
  end

end
