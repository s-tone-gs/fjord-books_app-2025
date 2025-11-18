# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'name_or_email return name when name is present' do
    user = users(:just_registered_user)

    assert_equal(user.name, user.name_or_email)
  end

  test 'name_or_email return email when name is not present' do
    user = users(:just_registered_user_without_name)

    assert_equal(user.email, user.name_or_email)
  end
end
