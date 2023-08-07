class Project < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  belongs_to :lead, class_name: "Membership", optional: true
  # 🚅 add belongs_to associations above.

  has_many :goals, dependent: :destroy, enable_updates: true

  has_many :applied_tags, class_name: "Projects::AppliedTag", dependent: :destroy
  has_many :tags, through: :applied_tags
  has_many :blocks, dependent: :destroy, enable_updates: true
  # 🚅 add has_many associations above.

  has_rich_text :description
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  validates :lead, scope: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_leads
    # raise "please review and implement `valid_leads` in `app/models/project.rb`."
    team.memberships.current_and_invited
    # please specify what objects should be considered valid for assigning to `lead`.
    # the resulting code should probably look something like `team.leads`.
  end

  def valid_tags
    # raise "please review and implement `valid_tags` in `app/models/project.rb`."
    team.projects_tags
    # please specify what objects should be considered valid for assigning to `tag_ids`.
    # the resulting code should probably look something like `team.tags`.
  end

  # 🚅 add methods above.
end
