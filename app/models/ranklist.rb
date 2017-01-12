class Ranklist
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  field :information, type: Array
  field :last_updated_time, type: DateTime
  field :submissions_count, type: Integer, default: 0
  belongs_to :contest
end
