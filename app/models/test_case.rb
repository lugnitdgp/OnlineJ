class TestCase
  include Mongoid::Document

  field :name, type: String, default: ''

  belongs_to :problem, counter_cache: true
end
