class SubmissionController < ApplicationController

  def verify_submission
    ccode = params[:ccode]
    pcode = params[:pcode]
    user_source_code = params[:user_source_code]
    language_name = params[:lang_name]
    language = Language.by_name(language_name).first
    if language.nil?
      render(file: 'public/404.html', status: :not_found, layout: false) && return
    end
    contest = Contest.by_code(ccode)
    if contest.nil?
      render(file: 'public/404.html', status: :not_found, layout: false) && return
    end
    problem = Problem.by_code(pcode)
    if problem.nil?
      render(file: 'public/404.html', status: :not_found, layout: false) && return
    end
    source_limit = problem[:source_limit]
    if user_source_code.length > source_limit
      flash[:error] = 'source limit exceeded'
      redirect_to(problem_path(ccode, pcode)) && return
    end
    latest_submission = current_user.submissions.by_created_at.first
    unless latest_submission.nil?
      if DateTime.now - latest_submission < 30
        flash[:error] = 'wait for 30s after the last submission'
        redirect_to(problem_path(ccode, pcode)) && return
      end
    end
    submission = Submission.new( submission_time: DateTime.now, user_source_code: user_source_code)
    current_user.submissions << submission
    language.submissions << submission
    problem.submissions << submission
    submission.save!
  end
end
