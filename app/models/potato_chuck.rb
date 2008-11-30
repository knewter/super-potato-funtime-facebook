class PotatoChuck < ActiveRecord::Base
  belongs_to :potato_man
  belongs_to :chucker, :class_name => "FacebookUser"
  belongs_to :chuckee, :class_name => "FacebookUser"

  after_create :send_feeds

  def send_feeds
    PotatoChuckPublisher.deliver_potato_chuck_feed(self)
  end
end
