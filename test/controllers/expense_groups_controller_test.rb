require 'test_helper'

class ExpenseGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @expense_group = expense_groups(:one)
  end

  test "should get index" do
    get expense_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_expense_group_url
    assert_response :success
  end

  test "should create expense_group" do
    assert_difference('ExpenseGroup.count') do
      post expense_groups_url, params: { expense_group: { name: @expense_group.name } }
    end

    assert_redirected_to expense_group_url(ExpenseGroup.last)
  end

  test "should show expense_group" do
    get expense_group_url(@expense_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_expense_group_url(@expense_group)
    assert_response :success
  end

  test "should update expense_group" do
    patch expense_group_url(@expense_group), params: { expense_group: { name: @expense_group.name } }
    assert_redirected_to expense_group_url(@expense_group)
  end

  test "should destroy expense_group" do
    assert_difference('ExpenseGroup.count', -1) do
      delete expense_group_url(@expense_group)
    end

    assert_redirected_to expense_groups_url
  end
end
