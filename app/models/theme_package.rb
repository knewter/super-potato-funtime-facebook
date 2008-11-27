class ThemePackage < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :potato_background
  has_many :theme_package_widget_links
  has_many :widgets, :through => :theme_package_widget_links

  validates_uniqueness_of :name

  def add_widget(widget_id)
    ThemePackageWidgetLink.find_or_create_by_theme_package_id_and_widget_id(id, widget_id)
  end

  def remove_widget widget_id
    begin
      ThemePackageWidgetLink.find_by_theme_package_id_and_widget_id(id, widget_id).destroy
    rescue
    end
  end
end
