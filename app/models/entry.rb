class Entry < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  
  
  
  belongs_to :team
  # belongs_to :entryable, polymorphic: true
  delegated_type :entryable, types: %w[ Message Comment ]
  # 🚅 add belongs_to associations above.

  accepts_nested_attributes_for :entryable
  
  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.
  
  # 🚅 add scopes above.
  
  
  ENTRYABLE_TYPES = I18n.t('entries.fields.entryable_type.options').keys.map(&:to_s)
  
  
  validates :entryable_type, inclusion: {
  in: ENTRYABLE_TYPES, allow_blank: false, message: I18n.t('errors.messages.empty')
  }
  
  # validates :entryable_type, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def entryable_type_valid?
    ENTRYABLE_TYPES.include?(entryable_type)
  end

  def build_entryable(params = {})
    raise 'invalid entryable type' unless entryable_type_valid?
    self.entryable = entryable_type.constantize.new(params)
  end
  
  # 🚅 add methods above.
end
