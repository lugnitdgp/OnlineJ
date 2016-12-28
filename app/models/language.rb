class Language
  include Mongoid::Document

  field :name, type: String, default: ''
  field :time_multiplier,             type: Float, default: '1.0'
  field :lang_code,                   type: String, default: ''

  has_and_belongs_to_many :problems
  has_many :submissions

  scope :by_name, -> (name){ where(name: name) }
end
