class AddLeadToProjects < ActiveRecord::Migration[7.0]
  def change
    add_reference :projects, :lead, null: true, foreign_key: {to_table: "memberships"}
  end
end
