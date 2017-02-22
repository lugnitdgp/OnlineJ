class RejudgeWorker
  include Sidekiq::Worker

  sidekiq_options :failures => true, retry: 5

  def perform(args)
    # Do something
    submission_ids = args
    submission_ids.each do | submission_id |
      submission = submission = Submission.by_id(submission_id).first;
      unless submission.nil?
        submission.status_code = 'PE'
        submission.save!
        job_id = ProcessSubmissionWorker.perform_async(submission_id: submission[:_id].to_s)
        submission.update!(job_id: job_id)
      end
    end
  end
end
