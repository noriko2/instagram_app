module ApplicationHelper

  #ページことの完全なタイトルを返す
  def full_title(page_title = '')
    base_title = 'Instagram'
    if page_title.empty?
      base_title   # 暗黙の戻り値(return が省略)
    else
      page_title + ' | ' +  base_title
    end
  end

end
