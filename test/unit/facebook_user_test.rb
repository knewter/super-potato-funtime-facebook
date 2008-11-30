require 'test_helper'

class FacebookUserTest < ActiveSupport::TestCase
  def setup
    @user1 = facebook_users(:one)
    @user2 = facebook_users(:two)
    @potato_man = potato_men(:one)
  end

  def test_one_user_should_be_able_to_chuck_a_potato_at_another
    assert_difference("PotatoChuck.count") do
      chuck = @user1.chuck(@user2, @potato_man)
      assert_equal chuck.potato_man, @potato_man
      assert_equal chuck.chucker, @user1
      assert_equal chuck.chuckee, @user2
    end
  end
end
