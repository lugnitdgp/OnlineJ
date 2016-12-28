class Problem
  include Mongoid::Document

  include Mongoid::Timestamps::Created::Short
  field :pcode,             type: String, default: ''
  field :pname,             type: String, default: ''
  field :statement,         type: String, default: ''
  field :state,             type: Boolean, default: true
  field :time_limit,        type: Float, default: '1.0'
  field :memory_limit,      type: Integer, default: 268435456
  field :source_limit,      type: Integer, default: 51200
  field :submissions_count, type: Integer, default: 0
  field :max_score,         type: Integer, default: 20

  belongs_to :contest, counter_cache: true
  has_and_belongs_to_many :users
  belongs_to :setter, counter_cache: true
  has_many :submissions, dependent: :destroy
  has_and_belongs_to_many :languages
  has_and_belongs_to_many :languages

  scope :by_code, -> (pcode){ where(pcode: pcode, state: true) }
end
