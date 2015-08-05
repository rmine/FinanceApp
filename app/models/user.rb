require "digest/md5"

class User < ActiveRecord::Base
  include PublicConstant

  has_many :collects
  has_many :comments,:class_name => "ContentComment"
  has_many :praises

  # attr_accessible :username,
  #                 :password,
  #                 :avatar,
  #                 :email,
  #                 :nick,
  #                 :idfa,
  #                 :oauth_type,
  #                 :uid,
  #                 :created_at,
  #                 :updated_at

  scope :info, proc {|user_id| where('id=?', user_id)}

  scope :oauth_type_of, ->(oauth_type){where('oauth_type = ? ', oauth_type) if oauth_type.to_i > -1 and oauth_type.present? }

  scope :by_username, ->(username){where('username like ?', "%#{username}%") if username.present?}

  scope :by_nick, ->(nick){where('nick like ?', "%#{nick}%") if nick.present?}

  def self.auth(username, password)
    where('username = ? and password = ?', username, Digest::MD5.hexdigest(password)).present?
  end

  def self.create_with_params(params)
    #第三方用户不需要用户名和密码,创建时过滤掉
    if params[:oauth_type].present? && params[:uid].present?
      user = User.new(params.delete_if{|k,v| k == 'username' || k == 'password'})
    else
      if params[:avatar].present?
        avatar = params[:avatar]
        image_info = PublicConstant::ImageHandle.upload_image(avatar,"avatars")
        avatar = PublicConstant::ImageHandle.qiniu_file(image_info)
        params.merge!(:avatar=>avatar)
      end
      user = User.new(params.merge(:password=>Digest::MD5.hexdigest(params[:password]), :avatar=>avatar ))
    end
    user
  end

  def self.update_with_params(user, params)
    user.update_attributes(params)
    user
  end

  def type_name
    SEARCH_OAUTH_TYPE_HASH_INVERT[oauth_type]
  end

  def self.scope_paginate(params)
    oauth_type = params[:oauth_type].blank? ? User::OAUTH_TP_ALL : params[:oauth_type]
    self.oauth_type_of(oauth_type).by_username(params[:username]).by_nick(params[:nick]).paginate(:page => params[:page], :per_page => 20)
  end

end
