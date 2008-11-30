class FacebookUser < ActiveRecord::Base
  validates_presence_of   :facebook_user_id
  validates_uniqueness_of :facebook_user_id

  has_many :potato_chucks_from, :class_name => "PotatoChuck", :foreign_key => "chucker_id"
  has_many :potato_chucks_at,   :class_name => "PotatoChuck", :foreign_key => "chuckee_id"

  def self.for(facebook_user_id, facebook_session=nil)
    returning find_or_create_by_facebook_user_id(facebook_user_id) do |user|
      unless facebook_session.nil?
        user.store_session(facebook_session.session_key)
      end
    end
  end

  def store_session(session_key)
    if self.session_key != session_key
      update_attribute(:session_key, session_key)
    end
  end

  def facebook_session
    @facebook_session ||=
      returning Facebooker::Session.create do |session|
        session.secure_with!(session_key, facebook_user_id, 1.hour.from_now)
      end
  end

  def chuck(other_user, potato_man)
    potato_chucks_from.create!(:chuckee => other_user, :potato_man => potato_man)
  end
end
