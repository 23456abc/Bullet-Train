require "controllers/api/v1/test"

class Api::V1::BlocksControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @project = create(:project, team: @team)
    @block = build(:block, project: @project)
    @other_blocks = create_list(:block, 3)

    @another_block = create(:block, project: @project)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @block.save
    @another_block.save
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(block_data)
    # Fetch the block in question and prepare to compare it's attributes.
    block = Block.find(block_data["id"])

    assert_equal_or_nil block_data['name'], block.name
    assert_equal_or_nil block_data['path'], block.path
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal block_data["project_id"], block.project_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/projects/#{@project.id}/blocks", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    block_ids_returned = response.parsed_body.map { |block| block["id"] }
    assert_includes(block_ids_returned, @block.id)

    # But not returning other people's resources.
    assert_not_includes(block_ids_returned, @other_blocks[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/blocks/#{@block.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/blocks/#{@block.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    block_data = JSON.parse(build(:block, project: nil).to_api_json.to_json)
    block_data.except!("id", "project_id", "created_at", "updated_at")
    params[:block] = block_data

    post "/api/v1/projects/#{@project.id}/blocks", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/projects/#{@project.id}/blocks",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/blocks/#{@block.id}", params: {
      access_token: access_token,
      block: {
        name: 'Alternative String Value',
        path: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @block.reload
    assert_equal @block.name, 'Alternative String Value'
    assert_equal @block.path, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/blocks/#{@block.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Block.count", -1) do
      delete "/api/v1/blocks/#{@block.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/blocks/#{@another_block.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
