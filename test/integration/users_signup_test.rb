require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'does not create a user when validation fails' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation', /name can't be blank/i

    assert_select 'div.field_with_errors', 8
  end

  test 'creates a new user' do
    get signup_path
    assert_difference 'User.count' do
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password: "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end
end
