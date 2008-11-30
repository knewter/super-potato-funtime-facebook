require 'RMagick'
class PotatoMan < ActiveRecord::Base
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :theme_package
  has_many :widget_instances
  has_many :widgets, :through => :widget_instances
  acts_as_rateable

  named_scope :active, :conditions => "theme_package_id IS NOT NULL"
  
  def feature!
    PotatoMan.find(:all, :conditions => {:featured => true}).each do |potato_man|
      potato_man.update_attribute(:featured, false)
    end
    self.update_attribute(:featured, true)
    self.write_featured!
  end

  def self.featured_potato_man
    potato_man = PotatoMan.find(:first, :conditions => {:featured => true }) rescue nil
    if( potato_man )
     potato_man
    else
      PotatoMan.first.write_featured!
      PotatoMan.first
    end
  end

  def write_preview!
    # This will write a preview of the image to the disk, so we can
    # composite the various layers using RMagick

    # First, get the background image ready.
    background_image = Magick::Image.read(potato_background.image.path)[0]

    # next, composite each of the widgets on top, ordered by their z-index
    widget_instances.sort_by{|w| w.z_index || '1' }.each do |widget_instance|
      this_widget_image = Magick::Image.read(widget_instance.widget.image.path)[0]
      background_image.composite!(this_widget_image, Magick::NorthWestGravity, widget_instance.left.to_i, widget_instance.top.to_i, Magick::OverCompositeOp)
    end
    background_image.write(preview_path_absolute)
    write_thumbnail!
  end

  def preview_path_absolute
    "#{RAILS_ROOT}/public#{preview_path}"
  end

  def preview_path
    "/potato_men/preview/#{id}.png"
  end

  def featured_path_absolute 
    "#{RAILS_ROOT}/public#{featured_path}"
  end

  def featured_path
    "/potato_men/featured/#{id}.png"
  end

  def thumbnail_path_absolute
    "#{RAILS_ROOT}/public#{thumbnail_path}"
  end

  def thumbnail_path
    "/potato_men/thumbnail/#{id}.png"
  end

  def write_thumbnail!
    img = Magick::Image.read(preview_path_absolute).first
    img.change_geometry!("200x200>") do |cols, rows, image|
      image.resize!(cols, rows)
    end
    img.write(thumbnail_path_absolute)
  end

  def write_featured!
    img = Magick::Image.read(preview_path_absolute).first
    img.change_geometry!("391x438>") do |cols, rows, image|
      image.resize!(cols, rows)
    end
    img.write(featured_path_absolute)
  end

  def potato_background
    theme_package.potato_background
  end
end
