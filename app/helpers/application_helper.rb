# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # title will output an h1 as well as update the title of the page
  def title string
    @title = string
    "<h1 id='page_title'>#{string}</h1>"
  end

  # title_for is the helper intended to be used to output the text
  # in the title tag of the layout.
  def title_for string
    if @title
      "#{@title} | #{string}"
    else
      string
    end
  end
end
