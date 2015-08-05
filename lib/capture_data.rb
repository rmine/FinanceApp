# coding: utf-8
require "open-uri"
require "nokogiri"
require "net/http"
require "uri"

class CaptureData
  #joke
  QIUBAI = 0
  #news
  SINA = 0
  WANGYI = 1
  #pics
  JIWA = 0

  def self.http_deal(url, has_proxy=false)
    uri = URI.parse(url)
    if has_proxy
      response = Net::HTTP::Proxy('192.168.16.189',8080,'huangzhaorong','22222222').get_response(uri)
    else
      response = Net::HTTP.get_response(uri)
    end

    response
  end

  def self.parse_html(html_data)
    Nokogiri::HTML(html_data)
   end

  def self.parse_xml(xml_data)
    Nokogiri::XML(xml_data)
  end

  def self.create_content(params={})
    if params.present?
      content = {:content_type=>params[:content_type],
                 :title=>params[:title],
                 :author=>params[:author],
                 :content=>params[:content],
                 :pic=>params[:pic],
                 :source=>params[:source],
                 :source_id=>params[:source_id],
                 :created_at=>params[:created_at],
                 :state=>params[:state],
                 :praise_num=>Content.rand_int(100,500)
      }
      Content.new(content).save
    end
  end

  ##################  qiubai joke begin ##################
  def self.capture_qiubai
    url="http://www.qiushibaike.com/8hr/page/1"
    top_response = http_deal(url)
    if top_response.code.to_i == 200
      data = top_response.body
      doc=parse_html(data)
      doc.css('div.block.untagged.mb15').each{|p|
        content=p.css('div.content').text.gsub(/\n/,'')
        imgAddr = ""
        img=p.css('div.thumb img').each{|img|
          imgAddr=img.attr('src')
        }
        source_id = p.attr('id').split('_').last
        #有图的不抓，有水印
        if (imgAddr.nil? || imgAddr == "") && Content.where('content_type = ? and source = ? and source_id = ?',Content::JOKE, SINA, source_id).blank? && SensitiveWord.word_valid?(content)
          params = {:content_type => Content::JOKE,
                    :content => content,
                    :source => QIUBAI,
                    :source_id => source_id,
                    :state => Content::ST_APPROVED}
          create_content(params)
        end

      }
    end
  end
  ##################  qiubai joke end ##################

  ######################################################################################################################################################################################################

  ##################  sina news begin ##################
  def self.capture_sina_content(url)
    response = http_deal(url)
    html_data = response.body
    html_data.encode!("utf-8", "gbk",:undef => :replace, :replace => "?", :invalid => :replace)
    doc=parse_html(html_data)
    content = []
    imgAddr = ''

    if doc.css("div#artibody").present?
      doc.css("div#artibody").each do |p|
        #File.open("1.txt",'w'){|f| f.write p}
        p.css('p').each do |cp|
          content << cp.text.gsub(/\n- /,'')+"\n"
        end
        p.css('div.img_wrapper img').each{|img|
          imgAddr=img.attr('src')
        }
      end
    else
      doc.css("div.blkContainerSblkCon.BSHARE_POP").each do |p|
        #File.open("1.txt",'w'){|f| f.write p}
        p.css('p').each do |cp|
          content << cp.text.gsub(/\n- /,'')+"\n"
        end
        p.css('div.img_wrapper img').each{|img|
          imgAddr=img.attr('src')
        }
      end
    end


    {'content'=>content.join(" "), 'pic'=>imgAddr}
  end

  def self.rss_list(url)
    response = http_deal(url)
    html_data = response.body
    doc=parse_xml(html_data)
    doc.xpath("//item").each do |p|
      url = p.css("link").text.split("url=").last
      if !url.include?("video")
        title = p.css("title").text.gsub("\n","").gsub("\t","").gsub(/\(\d+\/\d+\s\d+\:\d+\)/, "")
        pubDate = p.css("pubDate").text.to_datetime

        pre_content = Content.where('content_type = ? and source = ? and title like ?',Content::NEWS,SINA,"%#{title.split(']').last}%").first
        if pre_content.blank?
          news_content = self.capture_sina_content(url)
          if news_content['content'].present?
            params = {:content_type=>Content::NEWS,
                      :title=>title,
                      :author=>nil,
                      :content=>news_content['content'],
                      :pic=>news_content['pic'],
                      :source=>SINA,
                      :created_at=>pubDate,
                      :state=>Content::ST_APPROVED
            }
            create_content(params)
          end
        end

      end
    end
  end


  def self.capture_sina_article
    url="http://rss.sina.com.cn/sina_news_opml.xml"
    top_response = http_deal(url)
    if top_response.code.to_i == 200

      xml_data = top_response.body
      doc=parse_xml(xml_data)
      doc.css("outline").each do |p|
        if p.attr('xmlUrl')
          self.rss_list(p.attr('xmlUrl'))
        end
      end
    end
  end
  ##################  sina news end ##################

  ##################  wangyi news start ##################
  def self.capture_wangyi_article
    url = "http://www.163.com/rss/"
    top_response = http_deal(url)
    if top_response.code.to_i == 200
      html_data = top_response.body.encode!("utf-8", "gbk",:undef => :replace, :replace => "?", :invalid => :replace)
      doc=parse_html(html_data)

      doc.css("div.tList li").each do |p|
        href = p.css("a").attr('href').value
        pubDate = p.css("span").text
        #此处屏蔽子域名来控制收录频道内容
        if href.present? && /^\d{4}-\d{2}-\d{2}$/ === pubDate && href.end_with?(".html") &&  href.start_with?("http://news.163.com", "http://discovery.163.com", "http://sports.163.com", "http://tech.163.com", "http://money.163.com")
          if pubDate > Time.now - 1.day
            title = p.css("a").text
            pubDate = p.css("span").text.to_datetime

            pre_content = Content.where('content_type = ? and source = ? and title like ?',Content::NEWS,WANGYI,"%#{title}%").first
            if pre_content.blank?
              news_content = self.capture_wangyi_content(href)
              if news_content['content'].present?
                params = {:content_type=>Content::NEWS,
                          :title=>title,
                          :author=>nil,
                          :content=>news_content['content'],
                          :pic=>news_content['pic'],
                          :source=>WANGYI,
                          :created_at=>pubDate,
                          :state=>Content::ST_APPROVED
                }
                create_content(params)
              end
            end
          end
        end

      end

    end
  end


  def self.capture_wangyi_content(url)
    response = http_deal(url)
    html_data = response.body
    html_data.encode!("utf-8", "gbk",:undef => :replace, :replace => "?", :invalid => :replace)
    doc=parse_html(html_data)
    content = []
    imgAddr = ''

    if doc.css("#epContentLeft").present?
      doc.css("#endText").each do |p|
        p.css('p').each do |cp|
          if !cp.text.include?("#endText")
            content << cp.text.gsub(/\n- /,'')+"\n"
          end
        end
        p.css('p.f_center img').each{|img|
          imgAddr=img.attr('src')
        }
      end
    else
      doc.css("#endText").each do |p|
        p.css('p').each do |cp|
          if !cp.text.include?("#endText")
            content << cp.text.gsub(/\n- /,'')+"\n"
          end
        end
        p.css('p.f_center img').each{|img|
          imgAddr=img.attr('src')
        }
      end
    end
    if imgAddr.end_with?("end_i.gif","end_ent.png", "end_news.png", "end_money.png", "end_tech.png", "end_sports.png")
      imgAddr = ""
    end
    content = content.split("新闻回顾\n").first

    {'content'=>content.join(" "), 'pic'=>imgAddr}
  end
  ##################  wangyi news end ##################

  ################################################################################################################################################################################################################################################################################################

  ##################  jiwai pics start ##################
  def self.capture_jiwai_pics
    url="http://www.3jy.com/egao/"
    top_response = http_deal(url)
    if top_response.code.to_i == 200
      data = top_response.body
      doc=parse_html(data)
      doc.css('div.xh.clearfix').each{|p|
        imgAddr = ""
        content = ""
        p.css('div.listpic img').each{|img|
          imgAddr = img.attr('src')
          content = img.attr('title').split('_').last
        }
        source_id= p.css('h2').attr('id').value.split('_').last
        if imgAddr.present?  && Content.where('content_type = ? and source_id = ?',Content::PIC,source_id).blank?
          params = {:content_type => Content::PIC,
                    :pic => imgAddr,
                    :content => content,
                    :source => JIWA,
                    :source_id => source_id,
                    :state => Content::ST_APPROVED}
          create_content(params)
        end

      }
    end
  end
  ##################  jiwai pics end ##################

end



