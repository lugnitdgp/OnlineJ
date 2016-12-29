class SubmissionController < ApplicationController
  def index
    @title = 'Submission'
    query = get_query_from_params(params)
    @Submissions = Submission.by_query(query).sort({ created_at: -1})
    @Users = []
    @Contests = []
    @Problems = []
    @Submissions.each do |submission|
      user = submission.user
      problem = submission.problem
      @Users << {name: user[:name], user_id: user[:_id], email: user[:email], college: user[:college]}
      @Problems << { name: problem[:pname], code: problem[:pcode] }
      @Contests << submission.problem.contest[:ccode]
    end
  end

  def verify_submission
    ccode = params[:ccode]
    pcode = params[:pcode]
    user_source_code = params[:user_source_code]
    language_name = params[:lang_name]
    language = Language.by_name(language_name).first
    if language.nil?
      render(file: 'public/404.html', status: :not_found, layout: false) && return
    end
    contest = Contest.by_code(ccode).first
    if contest.nil?
      render(file: 'public/404.html', status: :not_found, layout: false) && return
    end
    problem = Problem.by_code(pcode).first
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
    submission = Submission.new(submission_time: DateTime.now, user_source_code: user_source_code)
    current_user.submissions << submission
    language.submissions << submission
    problem.submissions << submission
    submission.save!
  end

  private

  def get_query_from_params(params)
    puts params
    user_id = params[:user_id]
    ccode = params[:ccode]
    pcode = params[:pcode]
    query = {}
    unless ccode.nil?
      contest = Contest.by_code(ccode).first
      if contest.nil?
        render(file: 'public/404.html', status: :not_found, layout: false) && return
      else
        if pcode.nil?
          problem_ids = contest.problems.map(&:_id)
          query.merge! ({ :problem_id.in => problem_ids })
        else
          problem = Problem.by_code(pcode).first
          if problem.nil?
            render(file: 'public/404.html', status: :not_found, layout: false) && return
          else
            query.merge! ({ problem_id: pcode })
          end
        end
      end
    end
    unless user_id.nil?
      user = User.by_id(user_id).first
      if user.nil?
        render(file: 'public/404.html', status: :not_found, layout: false) && return
      else
        query.merge! ({ user_id: user_id })
      end
    end
    query
  end
end
