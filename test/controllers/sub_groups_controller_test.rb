require 'test_helper'

class SubGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sub_group = sub_groups(:one)
  end

  test "should get index" do
    get sub_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_sub_group_url
    assert_response :success
  end

  test "should create sub_group" do
    assert_difference('SubGroup.count') do
      post sub_groups_url, params: { sub_group: { name: @sub_group.name } }
    end

    assert_redirected_to sub_group_url(SubGroup.last)
  end

  test "should show sub_group" do
    get sub_group_url(@sub_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_sub_group_url(@sub_group)
    assert_response :success
  end

  test "should update sub_group" do
    patch sub_group_url(@sub_group), params: { sub_group: { name: @sub_group.name } }
    assert_redirected_to sub_group_url(@sub_group)
  end

  test "should destroy sub_group" do
    assert_difference('SubGroup.count', -1) do
      delete sub_group_url(@sub_group)
    end

    assert_redirected_to sub_groups_url
  end
end
