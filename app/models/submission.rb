class Submission
  include Mongoid::Document

  include Mongoid::Timestamps::Created::Short

  field :status_code,                   type: String, default: ''
  field :submission_time,               type: DateTime, default: DateTime.now
  field :user_source_code,              type: String, default: ''
  field :error_desc,                    type: String, default: ''
  field :time_taken,                    type: Float

  belongs_to :user, counter_cache: true
  belongs_to :problem, counter_cache: true
  belongs_to :language

  scope :by_created_at, -> { where(created_at: -1) }
end
