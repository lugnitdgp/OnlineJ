class Contest
  include Mongoid::Document

  include Mongoid::Timestamps::Created::Short
  field :cname, type: String, default: ''
  field :ccode,                  type: String, default: ''
  field :state,                  type: Boolean, default: true
  field :start_time,             type: DateTime, default: DateTime.now
  field :end_time,               type: DateTime, default: DateTime.now + 3.hours
  field :details,                type: String, default: ''

  index({ ccode: 1 }, unique: true)

  has_many :problems, dependent: :destroy
  has_one :ranklist, dependent: :destroy
  belongs_to :setter, counter_cache: true
  belongs_to :tester, optional: true
  has_many :announcements, dependent: :destroy, inverse_of: :contest
  has_and_belongs_to_many :users

  accepts_nested_attributes_for :announcements, allow_destroy: true

  scope :upcomming, -> { where(start_time: { :$gt => DateTime.now }, state: true) }
  scope :running, -> { where(start_time: { :$lte => DateTime.now }, end_time: { :$gte => DateTime.now }, state: true) }
  scope :past, -> { where(end_time: { :$lt => DateTime.now }, state: true) }
  scope :by_code, ->(ccode) { where(ccode: ccode, state: true) }
  scope :by_code_test, ->(ccode) { where(ccode: ccode) }
  scope :myContests, ->(current_user) { any_of({ setter: current_user.setter }, { :tester_id.in => current_user.tester_ids }) }

  before_save :strip_ccode
  after_create :create_ranklist, :create_contest_data
  after_destroy :delete_contest_data
  after_save :set_setter_tester

  def to_s
    ccode
  end

  def title
    to_s
  end

  def all_problems
    problems.where(state: true).order_by(submissions_count: -1)
  end

  def set_setter_tester
    problems.each do |problem|
      problem.save!
    end
  end

  def all_problems_test
    problems.all.order_by(submissions_count: -1)
  end

  def strip_ccode
    self[:ccode] = self[:ccode].strip
  end

  def create_contest_data
    system 'mkdir', '-p', "#{CONFIG[:base_path]}/#{self[:ccode]}"
    true
  end

  def create_ranklist
    @ranklist = Ranklist.new
    @ranklist.contest_id = self[:ccode]
    self.ranklist = @ranklist
    @ranklist.save!
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
