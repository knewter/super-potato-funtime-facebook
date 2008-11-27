class Widget < ActiveRecord::Base
  has_many :theme_package_widget_links
  has_many :theme_packages, :through => :theme_package_widget_links
  belongs_to :widget_category
  has_many :widget_instances, :dependent => :destroy
  has_many :potato_men, :through => :widget_instances

  has_attached_file :image, :path => ":rails_root/public/:class/:attachment/:id/:style/:basename.:extension", 
                            :url => "/:class/:attachment/:id/:style/:basename.:extension",
                            :styles => {:thumb => "100x100>"}
end
