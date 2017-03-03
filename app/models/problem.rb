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

  index({ pcode: 1 }, unique: true)

  belongs_to :contest, counter_cache: true
  belongs_to :setter, counter_cache: true
  has_many :submissions, dependent: :destroy
  has_many :test_cases, dependent: :destroy, inverse_of: :problem
  has_many :comment, dependent: :destroy
  has_and_belongs_to_many :languages

  accepts_nested_attributes_for :test_cases, allow_destroy: true

  scope :by_code, ->(pcode) { where(pcode: pcode, state: true) }
  before_create :create_problem_data
  after_destroy :delete_problem_data

  def to_s
    pcode
  end

  def title
    to_s
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
