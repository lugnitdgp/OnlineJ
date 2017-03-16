class TestCase
  include Mongoid::Document
  include Mongoid::Paperclip

  field :name, type: String, default: ''
  field :rejudge_submission, type: Boolean, default: false

  has_mongoid_attached_file :testcase
  has_mongoid_attached_file :testcase_output
  do_not_validate_attachment_file_type :testcase
  do_not_validate_attachment_file_type :testcase_output

  belongs_to :problem, counter_cache: true, index: true, inverse_of: :test_cases

  before_create :create_test_data
  after_destroy :delete_test_data

  def to_s
    name
  end

  def title
    to_s
  end

  def create_test_data
    problem = self.problem
    ccode = problem.contest[:ccode]
    system 'mkdir', '-p', "#{CONFIG[:base_path]}/#{ccode}/#{self.problem[:pcode]}/#{self[:name]}"
    testcase = File.open("#{CONFIG[:base_path]}/#{ccode}/#{self.problem[:pcode]}/#{self[:name]}/testcase", 'w')
    testcase.write(Paperclip.io_adapters.for(self.testcase).read)
    testcase.close
    testcase_output = File.open("#{CONFIG[:base_path]}/#{ccode}/#{self.problem[:pcode]}/#{self[:name]}/testcase_output", 'w')
    testcase_output.write(Paperclip.io_adapters.for(self.testcase_output).read)
    testcase_output.close
    if self.rejudge_submission?
      if problem.submissions?
        submissions = problem.submissions
        submission_ids = submissions.pluck(:id).collect(&:to_s)
        RejudgeWorker.perform_async(submission_ids)
      end
    end
    true
  end

  def delete_test_data
    problem = self.problem
    ccode = problem.contest[:ccode]
    system 'rm', '-rf', "#{CONFIG[:base_path]}/#{ccode}/#{self.problem[:pcode]}/#{self[:name]}"
    if self.rejudge_submission?
      if problem.submissions?
        submissions = problem.submissions
        submission_ids = submissions.pluck(:id).collect(&:to_s)
        RejudgeWorker.perform_async(submission_ids)
      end
    end
    true
  end
end
