class PotatoBackground < ActiveRecord::Base
  has_attached_file :image, :path => ":rails_root/public/:class/:attachment/:id/:style/:basename.:extension", 
                            :url => "/:class/:attachment/:id/:style/:basename.:extension",
                            :styles => { :thumb => "100x100>" } 

  has_many :theme_packages
end
