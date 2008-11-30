class PotatoChuckPublisher < Facebooker::Rails::Publisher
  helper :application

  def potato_chuck_feed(potato_chuck)
    send_as :user_action
    from potato_chuck.chucker.facebook_session.user
    data :defender => name(potato_chuck.chuckee),
         :images => [image(potato_chuck.potato_man.thumbnail_path, public_potato_man_url(potato_chuck.potato_man))]
  end

  def potato_chuck_feed_template
    one_line_story_template "{*actor*} chucked a potato at {*defender*}"
    short_story_template "{*actor*} engaged in a potato chucking contest.",
        "{*actor*} chucked a potato at {*defender*}"
  end
end
