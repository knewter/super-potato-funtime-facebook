class User < ActiveRecord::Base
  has_many :identity_urls, :dependent => :destroy
  has_many :theme_packages, :foreign_key => 'creator_id'
  has_many :potato_men, :foreign_key => 'creator_id'


  # For those without open id logins
  def self.create_anonymous_user
    user = User.new
    user.nickname = "anonymous_coward_" + Time.now.to_i.to_s
    user.email = "anon@superpotatofuntime.com"
    user.save
    user
  end

end
