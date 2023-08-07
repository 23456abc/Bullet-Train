require "controllers/api/v1/test"

class Api::V1::FoldersControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @office = create(:office, team: @team)
    @folder = build(:folder, office: @office)
    @other_folders = create_list(:folder, 3)

    @another_folder = create(:folder, office: @office)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @folder.save
    @another_folder.save
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(folder_data)
    # Fetch the folder in question and prepare to compare it's attributes.
    folder = Folder.find(folder_data["id"])

    assert_equal_or_nil folder_data['name'], folder.name
    assert_equal_or_nil folder_data['path'], folder.path
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal folder_data["office_id"], folder.office_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/offices/#{@office.id}/folders", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    folder_ids_returned = response.parsed_body.map { |folder| folder["id"] }
    assert_includes(folder_ids_returned, @folder.id)

    # But not returning other people's resources.
    assert_not_includes(folder_ids_returned, @other_folders[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/folders/#{@folder.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/folders/#{@folder.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    folder_data = JSON.parse(build(:folder, office: nil).to_api_json.to_json)
    folder_data.except!("id", "office_id", "created_at", "updated_at")
    params[:folder] = folder_data

    post "/api/v1/offices/#{@office.id}/folders", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/offices/#{@office.id}/folders",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/folders/#{@folder.id}", params: {
      access_token: access_token,
      folder: {
        name: 'Alternative String Value',
        path: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @folder.reload
    assert_equal @folder.name, 'Alternative String Value'
    assert_equal @folder.path, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/folders/#{@folder.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Folder.count", -1) do
      delete "/api/v1/folders/#{@folder.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/folders/#{@another_folder.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
