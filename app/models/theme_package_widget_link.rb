class ThemePackageWidgetLink < ActiveRecord::Base
  belongs_to :widget
  belongs_to :theme_package
end
