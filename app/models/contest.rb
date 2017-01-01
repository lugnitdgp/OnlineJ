class Contest
  include Mongoid::Document

  include Mongoid::Timestamps::Created::Short
  field :cname, type: String, default: ''
  field :ccode,                  type: String, default: ''
  field :state,                  type: Boolean, default: false
  field :start_time,             type: DateTime, default: DateTime.now
  field :end_time,               type: DateTime, default: DateTime.now + 3.hours
  field :details,                type: String, default: ''

  has_many :problems, dependent: :destroy
  belongs_to :setter, counter_cache: true
  has_and_belongs_to_many :users

  scope :upcomming, -> { where(start_time: { :$gt => DateTime.now }, state: true) }
  scope :running, -> { where(start_time: { :$lte => DateTime.now }, end_time: { :$gte => DateTime.now }, state: true) }
  scope :past, -> { where(end_time: { :$lt => DateTime.now }, state: true) }
  scope :by_code, ->(ccode) { where(ccode: ccode, state: true) }

  before_create :create_contest_data
  after_destroy :delete_contest_data

  def all_problems
    problems.where(state: true).order_by(submissions_count: -1)
  end

  def create_contest_data
    system 'mkdir', '-p', "#{CONFIG[:base_path]}/#{self[:ccode]}"
    true
  end

  def delete_contest_data
    users = self.users
    system 'rm', '-rf', "#{CONFIG[:base_path]}/#{self[:ccode]}"
    users.each do |user|
      system 'rm', '-rf', "#{CONFIG[:base_path]}/#{user[:email]}/#{ccode}"
    end
    true
  end
end
