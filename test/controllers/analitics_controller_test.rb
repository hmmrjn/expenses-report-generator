require 'test_helper'

class AnaliticsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get analitics_index_url
    assert_response :success
  end

end
