module ContentsHelper
  def get_pic(pic)
    pic.blank? ? '<button id="pic_img" type="button" class="btn btn-default">上传图片</button>':"<img id='pic_img' src='#{@content.pic}' >"
  end
end