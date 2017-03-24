class Problem
  include Mongoid::Document

  include Mongoid::Timestamps::Created::Short
  field :pcode,             type: String, default: ''
  field :pname,             type: String, default: ''
  field :statement,         type: String, default: ''
  field :state,             type: Boolean, default: false
  field :time_limit,        type: Integer, default: 1
  field :memory_limit,      type: Integer, default: 268_435_456
  field :source_limit,      type: Integer, default: 51_200
  field :diff,              type: String, default: '-Bb'
  field :difficulty,        type: String, default: '-'
  field :submissions_count, type: Integer, default: 0
  field :max_score,         type: Integer, default: 20

  belongs_to :contest, counter_cache: true
  belongs_to :setter, counter_cache: true
  belongs_to :tester, optional: true
  has_many :submissions, dependent: :destroy
  has_many :test_cases, dependent: :destroy, inverse_of: :problem
  has_many :comment, dependent: :destroy
  has_and_belongs_to_many :languages

  accepts_nested_attributes_for :test_cases, allow_destroy: true
  validates :pcode, uniqueness: { scope: :contest }, presence: true

  scope :by_code, ->(pcode) { where(pcode: pcode, state: true) }
  scope :by_code_all, ->(pcode) { where(pcode: pcode) }
  after_create :create_problem_data
  before_save :strip_pcode_and_tester
  after_destroy :delete_problem_data

  def to_s
    pcode
  end

  def title
    to_s
  end

  def strip_pcode_and_tester
    self[:pcode] = self[:pcode].strip
    self.tester = contest.tester
    self.setter = contest.setter
  end

  def create_problem_data
    system 'mkdir', '-p', "#{CONFIG[:base_path]}/#{contest[:ccode]}/#{self[:pcode]}"
    true
  end

  def delete_problem_data
    contest = self.contest
    users = contest.users
    system 'rm', '-rf', "#{CONFIG[:base_path]}/#{contest[:ccode]}/#{self[:pcode]}"
    users.each do |user|
      system 'rm', '-rf', "#{CONFIG[:base_path]}/#{user[:email]}/#{contest[:ccode]}/#{self[:pcode]}"
    end
    true
  end
end
