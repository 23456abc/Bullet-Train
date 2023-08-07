require "controllers/api/v1/test"

class Api::V1::EntriesControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @entry = build(:entry, team: @team)
    @other_entries = create_list(:entry, 3)

    @another_entry = create(:entry, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @entry.save
    @another_entry.save
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(entry_data)
    # Fetch the entry in question and prepare to compare it's attributes.
    entry = Entry.find(entry_data["id"])

    assert_equal_or_nil entry_data['entryable_type'], entry.entryable_type
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal entry_data["team_id"], entry.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/entries", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    entry_ids_returned = response.parsed_body.map { |entry| entry["id"] }
    assert_includes(entry_ids_returned, @entry.id)

    # But not returning other people's resources.
    assert_not_includes(entry_ids_returned, @other_entries[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/entries/#{@entry.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/entries/#{@entry.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    entry_data = JSON.parse(build(:entry, team: nil).to_api_json.to_json)
    entry_data.except!("id", "team_id", "created_at", "updated_at")
    params[:entry] = entry_data

    post "/api/v1/teams/#{@team.id}/entries", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/entries",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/entries/#{@entry.id}", params: {
      access_token: access_token,
      entry: {
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @entry.reload
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/entries/#{@entry.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Entry.count", -1) do
      delete "/api/v1/entries/#{@entry.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/entries/#{@another_entry.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
