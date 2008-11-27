class WidgetInstance < ActiveRecord::Base
  belongs_to :potato_man
  belongs_to :widget

  after_save :write_images


  private 
  def write_images
    self.potato_man.write_preview!
    self.potato_man.write_thumbnail!
  end
end
