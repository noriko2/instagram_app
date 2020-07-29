require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup
    @relationship = Relationship.new(follower_id: users(:foo).id,
                                     followed_id: users(:wanko).id)
  end

  test "shuld be valid" do
    assert @relationship.valid?
  end

  test "shuld require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "shuld require a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end
