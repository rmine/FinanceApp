module PublicConstant
  ST_ALL = -1
  ST_NEW = 0
  ST_APPROVED = 1
  ST_DELETE = 2
  ST_REJECT = 3

  SEARCH_STATE_TYPE_HASH={
      '全部'=>ST_ALL,
      '新增'=>ST_NEW,
      '通过'=>ST_APPROVED,
      '删除'=>ST_DELETE,
      '拒绝'=>ST_REJECT
  }

  STATE_TYPE_HASH={
      '新增'=>ST_NEW,
      '通过'=>ST_APPROVED,
      '删除'=>ST_DELETE,
      '拒绝'=>ST_REJECT
  }

  STATE_TYPE_HASH_INVERT = STATE_TYPE_HASH.invert

  #第三方用户类型 0=normal, 1=sina, 2=qq
  OAUTH_TP_ALL = -1
  OAUTH_TP_NORMAL = 0
  OAUTH_TP_SINA = 1
  OAUTH_TP_QQ = 2

  SEARCH_OAUTH_TYPE_HASH={
      '全部'=>OAUTH_TP_ALL,
      '普通'=>OAUTH_TP_NORMAL,
      '新浪'=>OAUTH_TP_SINA,
      '腾讯'=>OAUTH_TP_QQ
  }

  SEARCH_OAUTH_TYPE_HASH_INVERT = SEARCH_OAUTH_TYPE_HASH.invert

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def rand_int(from, to)
      rand_in_range(from, to).to_i
    end

    def rand_price(from, to)
      rand_in_range(from, to).round(2)
    end

    def rand_time(from, to=Time.now)
      Time.at(rand_in_range(from.to_f, to.to_f))
    end

    def rand_in_range(from, to)
      rand * (to - from) + from
    end
  end

  class ImageHandle
    def initialize(imagedata)
      @imagedata = MiniMagick::Image.read(imagedata)
      @original_name = imagedata.original_name
    end


    def self.upload_image(pic,desc)
      suffix = File.extname(pic.original_filename)
      picdata = pic.read
      filename = "#{Digest::SHA1.hexdigest picdata}"+suffix
      path = "#{Rails.root}/public/files/#{desc}"
      FileUtils.mkdir(path) unless File.directory?(path)
      local_path = "#{path}/#{filename}"
      File.open(local_path, "wb+") do |f|
        f.write picdata
      end
      if File.exists?(local_path)
        # image_url = request.scheme + '://' + request.host_with_port + "/files/#{desc}/" + filename
        image_url = nil
        return {:image_url=>image_url,:file_path=>local_path,:filename=>filename}
      else
        return nil
      end
    end

    def create_thumbnail(source_path,size,desc,thumb_filename)
      img = Magick::Image.read(source_path).first  #读出原图片
      mutiple = size.fdiv(img.columns)  #mutiple为比例
      thumb = img.resize!(mutiple)  #按比例剪裁
      thumb.write("#{RAILS_ROOT}/public/files/#{desc}/"+thumb_filename)  #新图片
      if File.exists?("#{RAILS_ROOT}/public/files/#{desc}/"+thumb_filename)
        #服务器
        thumb_url = request.scheme + '://' + request.host_with_port + "/files/#{desc}/" + thumb_filename
        #本地
        # image_url = request.scheme + '://' + request.host_with_port + "/files/#{desc}/" + filename
        return thumb_url
      else
        return nil
      end
    end

    def save_image_to_file(image, path, filename)
      FileUtils.mkdir(path) unless File.directory?(path)
      File.open("#{path}/#{filename}", "w") do |f|
        f.write image
      end
    end

    def right_size?(image, width, height)
      image_mm = MiniMagick::Image.read(image)
      image_width = image_mm[:width]
      image_height = image_mm[:height]

      if image_width == width and image_height == height
        return true
      else
        return false
      end
    end

    #七牛文件路径获取
    def self.qiniu_file(image_info)
      put_policy = Qiniu::Auth::PutPolicy.new(
          'jokenewsworld',
      )
      #p uptoken = Qiniu::Auth.generate_uptoken(put_policy)
      result = Qiniu::Storage.upload_with_put_policy(
          put_policy,     # 上传策略
          image_info[:file_path],
          image_info[:filename]
      )
      if result[0] == 200
        qiniu_url = "http://jokenewsworld.qiniudn.com/#{image_info[:filename]}"
      else
        qiniu_url
      end

      qiniu_url
    end


  end



end