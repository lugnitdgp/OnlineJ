class Language
  include Mongoid::Document

  field :name, type: String, default: ''
  field :time_multiplier,             type: Integer, default: 1
  field :lang_code,                   type: String, default: ''
  field :snippet,                     type: String, default: ''
  has_and_belongs_to_many :problems
  has_many :submissions

  validates :name, presence: true
  validates :lang_code, uniqueness: true, presence: true

  before_save :strip_fields

  def strip_fields
    self[:name] = self[:name].strip
    self[:lang_code] = self[:lang_code].strip
  end

  scope :by_name, ->(name) { where(name: name) }
  scope :by_lang_code, ->(lang_code) { where(lang_code: lang_code) }
end
