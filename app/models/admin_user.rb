require 'digest/md5'

class AdminUser < ActiveRecord::Base

  def authenticate(password)
    self.password == Digest::MD5.hexdigest(password)
  end

end