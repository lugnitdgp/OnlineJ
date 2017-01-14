class SubmissionCronWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include Sidetiq::Schedulable

  sidekiq_options failures: true

  recurrence { hourly.minute_of_hour(0, 15, 30, 45) }

  def perform
    at 0, "checking PE submissions"
    submissions = Submission.where(status_code: 'PE')
    if submissions.nil?
      at 100, "done not found"
      return
    end
    submissions.each do |submission|
      queue = Sidekiq::Queue.new('default')
      enqueue = true
      queue.each do |job|
        enqueue = false if job.args[0]['submission_id'] == submission._id
      end
      args = {
        submission_id: submission[:_id].to_s
      }
      ProcessSubmissionWorker.perform_async(args) if enqueue
    end
  end
end
