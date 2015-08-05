class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user


  def current_user
    @current_user ||= AdminUser.find(session[:user_id]) if session[:user_id]
  end

  def session_url
    if session[:url_back].blank? || (session[:url_back].include?('sessions') && request.url.include?('sessions'))
      session[:url_back] = contents_url
    end
  end

  def verify_login
    if request.url.include? 'sessions'
      session[:url_back] = contents_url
    else
      session[:url_back] = request.url  
    end

    result = false
    if current_user.present?
      result = true
    else
      redirect_to sessions_url
    end
    result
  end

  def rand_str(len)
    result = ''
    chars   = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    1.upto(len) { |i| result << chars[rand(chars.size-1)] }
    result
  end

  def upload_image(pic,desc)
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
      image_url = request.scheme + '://' + request.host_with_port + "/files/#{desc}/" + filename
      return {:image_url=>image_url,:file_path=>local_path,:filename=>filename}
    else
      return nil
    end
  end

  def create_thumbnail(source_path,size,desc,thumb_filename)
    img = Magick::Image.read(source_path).first  #读出原图片
    mutiple = size.fdiv(img.columns)  #mutiple为比例
    thumb = img.resize!(mutiple)  #按比例剪裁
    thumb.write("#{Rails.root}/public/files/#{desc}/"+thumb_filename)  #新图片
    if File.exists?("#{Rails.root}/public/files/#{desc}/"+thumb_filename)
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
  def qiniu_file(image_info)
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
