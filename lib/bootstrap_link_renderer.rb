# 适应bootstrap样式分页
class BootstrapLinkRenderer < WillPaginate::ActionView::LinkRenderer
  protected
  def page_number(page)
    unless page == current_page
      tag(:li, link(page, page, :rel => rel_value(page)))       #设定非当前分页的页码链接
    else
      tag(:li, tag(:a, page, :href => "#"), :class => 'active') #设定当前分页的页码链接
    end
  end

  def gap
    text = @template.will_paginate_translate(:page_gap) { '&hellip;' }
    %(<li class="disabled"><a href="#">#{text}</a></li>)        #设定gap
  end

  def previous_or_next_page(page, text, classname)
    if page
      tag(:li, link(text, page, :class => classname))           #设定"上一页"和"下一页"可以使用的的链接
    else
      tag(:li, tag(:a, text, :href => "#"),
          :class =>'disabled')                                    #设定"上一页"和"下一页"不可用的链接
    end
  end

  def html_container(html)
    tag(:div, tag(:ul, html, :class=>'pagination'), container_attributes)             #加入ul标签
  end
end

# WillPaginate::ViewHelpers.pagination_options[:previous_label] = '上一页'
# WillPaginate::ViewHelpers.pagination_options[:next_label] = '下一页'