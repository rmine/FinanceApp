class Content < ActiveRecord::Base
  include PublicConstant

  has_many :collects, ->{ includes :collects}
  has_many :praises, ->{ includes :praises}
  has_many :content_comments

  # attr_accessible :content_type,
  #                 :title,
  #                 :content,
  #                 :pic,
  #                 :author,
  #                 :praise_num,
  #                 :comment_num,
  #                 :state,
  #                 :source,
  #                 :source_id,
  #                 :source_time,
  #                 :created_at

  ALL = -1
  JOKE = 0
  PIC = 1
  ARTICLE = 2
  NEWS = 3

  SEARCH_CONENT_TYPE_HASH={
      '全部'=>ALL,
      '笑话'=>JOKE,
      '趣图'=>PIC,
      '博文'=>ARTICLE,
      '新闻'=>NEWS
  }

  CONENT_TYPE_HASH={
      '笑话'=>JOKE,
      '趣图'=>PIC,
      '博文'=>ARTICLE,
      '新闻'=>NEWS
  }

  CONENT_TYPE_HASH_INVERT = CONENT_TYPE_HASH.invert


  #validates_presence_of :title,:message=>'标题字段不能为空'
  validates_presence_of :pic,:message=>'图片不能为空', :if => Proc.new { |content| content.content_type == PIC }


  scope :info, proc {|content_id| where('id=?', content_id)}

  scope :type_of, proc {|type| where(:content_type => type) if type.present? and type.to_i > -1 }

  scope :valid, proc {where(:state=>Content::ST_APPROVED)}

  scope :by_state, proc {|state| where(:state=>state) if state.present? and  state.to_i > -1}

  scope :by_time, proc {|time| where('contents.created_at < ?', time) if time.present?}

  scope :order_created_desc, ->{order('contents.created_at desc')}

  #精华内容，日周月
  scope :essence_by_time, proc {|time|
    where('contents.created_at >= ?', time)
  }

  def type_name
    CONENT_TYPE_HASH_INVERT[content_type]
  end

  def self.scope_paginate(params)
    state = params[:state].blank? ? Content::ST_ALL : params[:state]
    content_type = params[:content_type].blank? ? ALL : params[:content_type]
    self.by_state(state).type_of(content_type).paginate(:page => params[:page], :per_page => 20)
  end

end
