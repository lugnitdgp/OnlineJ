class Contest
  include Mongoid::Document

  include Mongoid::Timestamps::Created::Short
  field :name,                   type: String, default: ''
  field :ccode,                  type: String, default: ''
  field :state,                  type: Boolean, default: false
  field :start_time,             type: DateTime, default: DateTime.now
  field :end_time,               type: DateTime, default: DateTime.now + 3.hours
  field :details,                type: String, default: ''

  has_many :problems, dependent: :destroy
  belongs_to :setter, counter_cache: true
  has_and_belongs_to_many :users

  def all_problems
    self.problems.where({ state: true }).order_by({ submissions_count: -1 })
  end
end
