class Folder < ApplicationRecord
  include Sortable
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :office
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :team, through: :office
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def collection
    office.folders
  end

  # 🚅 add methods above.
end
