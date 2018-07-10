require "application_system_test_case"

class ExpenseGroupsTest < ApplicationSystemTestCase
  setup do
    @expense_group = expense_groups(:one)
  end

  test "visiting the index" do
    visit expense_groups_url
    assert_selector "h1", text: "Expense Groups"
  end

  test "creating a Expense group" do
    visit expense_groups_url
    click_on "New Expense Group"

    fill_in "Name", with: @expense_group.name
    click_on "Create Expense group"

    assert_text "Expense group was successfully created"
    click_on "Back"
  end

  test "updating a Expense group" do
    visit expense_groups_url
    click_on "Edit", match: :first

    fill_in "Name", with: @expense_group.name
    click_on "Update Expense group"

    assert_text "Expense group was successfully updated"
    click_on "Back"
  end

  test "destroying a Expense group" do
    visit expense_groups_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Expense group was successfully destroyed"
  end
end
