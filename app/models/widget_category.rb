class WidgetCategory < ActiveRecord::Base
  has_many :widgets
  validates_uniqueness_of :name
end
