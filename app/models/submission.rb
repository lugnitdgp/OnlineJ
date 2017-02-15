class Submission
  include Mongoid::Document

  include Mongoid::Timestamps::Created::Short

  field :status_code,                   type: String, default: 'PE'
  field :submission_time,               type: DateTime, default: DateTime.now
  field :user_source_code,              type: String, default: ''
  field :error_desc,                    type: String, default: ''
  field :time_taken,                    type: Float
  field :memory_taken,                  type: Integer
  field :job_id,                        type: String, default: ''
  # TODO: add memory_limit

  belongs_to :user, counter_cache: true
  belongs_to :problem, counter_cache: true
  belongs_to :language

  scope :latest, -> { order_by(created_at: -1) }
  scope :by_query, ->(query) { where(query) }
  scope :by_id, ->(id) { where(_id: id) }

  before_save :create_submission_data, on: :create
  after_destroy :delete_submission_data

  def create_submission_data
    ext_hash = { 'c++' => '.cpp', 'java' => '.java', 'python' => '.py', 'c' => '.c', 'ruby' => '.rb' }
    problem = self.problem
    ccode = problem.contest[:ccode]
    user_email = user[:email]
    lang_code = language[:lang_code]
    system 'mkdir', '-p', "#{CONFIG[:base_path]}/#{user_email}/#{ccode}/#{problem[:pcode]}/#{self[:_id]}"
    if lang_code == 'java'
      user_source_code = File.open("#{CONFIG[:base_path]}/#{user_email}/#{ccode}/#{problem[:pcode]}/#{self[:_id]}/Main#{ext_hash[lang_code]}", 'w')
    else
      user_source_code = File.open("#{CONFIG[:base_path]}/#{user_email}/#{ccode}/#{problem[:pcode]}/#{self[:_id]}/user_source_code#{ext_hash[lang_code]}", 'w')
    end
    user_source_code.write(self[:user_source_code])
    user_source_code.close
    problem.test_cases.each do |test_case|
      system 'mkdir', '-p', "#{CONFIG[:base_path]}/#{user_email}/#{ccode}/#{problem[:pcode]}/#{self[:_id]}/#{test_case[:name]}"
    end
    true
  end

  def delete_submission_data
    problem = self.problem
    ccode = problem.contest[:ccode]
    user_email = user[:email]
    system 'rm', '-rf', "#{CONFIG[:base_path]}/#{user_email}/#{ccode}/#{problem[:pcode]}/#{self[:_id]}"
    true
  end
end
