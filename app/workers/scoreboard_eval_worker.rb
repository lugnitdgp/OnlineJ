class ScoreboardEvalWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include Sidetiq::Schedulable
  sidekiq_options unique: :until_executed, queue: :scoreboard

  recurrence { hourly.minute_of_hour(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59) }

  def perform
    contests = Contest.where(start_time: { :$lte => DateTime.now }, end_time: { :$gt => DateTime.now - 5.minutes })
    return if contests.nil?
    contests.each do |contest|
      contest_start_time = contest[:start_time]
      ranklist = contest.ranklist
      contest_setter = contest.setter
      contest_users = contest.users
      contest_problems = contest.problems
      user_array = []
      return if contest_users.nil?

      total_submissions_count_ac = 0
      contest_problems.each do |problem|
        total_submissions_count_ac += problem.submissions.where(status_code: 'AC').order_by(submission_time: 1).count
      end

      next if total_submissions_count_ac == ranklist.submissions_count

      contest_users.each do |user|
        next if user.setter_id == contest_setter[:_id]
        problem_array = []
        total_time = contest_start_time
        total_success = 0
        total_score = 0
        total_penlty = 0
        contest_problems.each do |problem|
          problem_hash = { pcode: problem[:pcode], name: problem[:name], max_score: problem[:max_score] }
          problem_submissions = Submission.where(user_id: user[:_id], problem_id: problem[:_id])
          problem_submissions_ac = problem_submissions.where(status_code: 'AC').order_by(submission_time: 1)

          if problem_submissions_ac.count > 0
            user_ac_earliest_time = problem_submissions_ac.first[:submission_time]
            problem_hash.merge! ({ success_time: user_ac_earliest_time, success: true })
            user_not_ac_count = problem_submissions.where(:status_code.nin => %w(AC PE CE), :submission_time.lte => user_ac_earliest_time).count
            problem_hash.merge! ({ penalty_count: user_not_ac_count })
            total_penlty += user_not_ac_count
            total_time += user_ac_earliest_time - contest_start_time + user_not_ac_count * CONFIG[:penalty].minutes
            total_success += 1
            total_score += problem[:max_score]
          else
            problem_hash.merge! ({ success: false })
          end
          problem_array << problem_hash
        end
        unless total_success == 0
          user_hash = { username: user[:username], id: user[:id], college: user[:college] }
          user_hash.merge! ({ problems: problem_array, total_time: (total_time - contest_start_time) / 60, successes: total_success, total_score: total_score, total_penlty: total_penlty })
          user_array << user_hash
        end
      end
      user_array.sort! { |a, b| a[:successes] > b[:successes] ? -1 : (a[:successes] < b[:successes] ? 1 : (a[:total_time] <=> b[:total_time])) }
      last_updated_time = DateTime.now
      ranklist.update!(information: user_array, last_updated_time: last_updated_time, submissions_count: total_submissions_count_ac)
    end
    nil
  end
end
