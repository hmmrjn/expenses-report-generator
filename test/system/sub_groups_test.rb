require "application_system_test_case"

class SubGroupsTest < ApplicationSystemTestCase
  setup do
    @sub_group = sub_groups(:one)
  end

  test "visiting the index" do
    visit sub_groups_url
    assert_selector "h1", text: "Sub Groups"
  end

  test "creating a Sub group" do
    visit sub_groups_url
    click_on "New Sub Group"

    fill_in "Name", with: @sub_group.name
    click_on "Create Sub group"

    assert_text "Sub group was successfully created"
    click_on "Back"
  end

  test "updating a Sub group" do
    visit sub_groups_url
    click_on "Edit", match: :first

    fill_in "Name", with: @sub_group.name
    click_on "Update Sub group"

    assert_text "Sub group was successfully updated"
    click_on "Back"
  end

  test "destroying a Sub group" do
    visit sub_groups_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Sub group was successfully destroyed"
  end
end
