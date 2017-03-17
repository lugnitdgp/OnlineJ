class ContestController < ApplicationController
  before_action :check
  def index
    @test = params['test'] || false
    @contest_page = true
    @ccode = params[:ccode]
    contest = Contest.by_code(@ccode).cache.first
    authorize! :read, contest if @test
    if contest.nil?
      render(file: 'public/404.html', status: :not_found, layout: false) && return
    end
    @title = contest[:cname]
    problems = if @test
                 contest.all_problems_test
               else
                 contest.all_problems if contest[:start_time] <= DateTime.now
               end
    @Details = contest[:details]
    @start_time = contest[:start_time]
    @end_time = contest[:end_time]
    @announcements = (contest.announcements if contest.announcements.count > 0)
    success_sub = []
    unless problems.nil?
      problems.each { |problem| success_sub << problem.submissions.where(status_code: 'AC', test: false).distinct(:user).count }
      @problem_hash = { problems: problems, success_sub: success_sub }
    end
  end

  def problem
    @problem_page = true
    @ccode = params[:ccode]
    @pcode = params[:pcode]
    @test = params['test'] || false
    gon.contest = @ccode
    gon.problem = @pcode
    gon.test = @test
    @submission_id = params[:submission_id]
    contest = Contest.by_code(@ccode).first
    problem = if @test
                contest.problems.by_code_all(@pcode).first
              else
                contest.problems.by_code(@pcode).first
              end
    if problem.nil?
      render(file: 'public/404.html', status: :not_found, layout: false) && return
    end
    if !@test
      if problem.contest[:start_time] > DateTime.now || !problem.contest[:state]
        render(file: 'public/404.html', status: :not_found, layout: false) && return
      end
    else
      authorize! :read, problem
    end
    submission = problem.submissions.by_id(@submission_id).first
    if submission.nil? && !@submission_id.nil?
      render(file: 'public/404.html', status: :not_found, layout: false) && return
    elsif !submission.nil?
      authorize! :read, submission
      gon.submission = true
      gon.user_source_code = submission.user_source_code
      gon.lang_code = submission.language.lang_code
      gon.lang_name = submission.language.name
    end
    @cname = problem.contest[:cname]
    @title = problem[:pname]
    @statement = problem[:statement]
    @setter_name = problem.setter.user[:name]
    @setter_username = problem.setter.user[:username]
    @language_hash = get_language_data(problem, name: 'name', lang: 'lang_code')
    if user_signed_in?
      unless current_user[:default_language].blank?
        @language_hash.rotate!(@language_hash.index { |language| language[:code] == current_user[:default_language] })
      end
    end
    @score = problem[:max_score]
    @time_limit = problem[:time_limit]
    @memory_limit = problem[:memory_limit]
    @source_limit = problem[:source_limit]
    @difficulty = problem[:difficulty]
  end

  def comments
    @ccode = params[:ccode]
    @pcode = params[:pcode]
    contest = Contest.by_code(@ccode).first
    problem = contest.problems.by_code(@pcode).first
    @comments = problem.comment.order(created_at: 'desc').page(params[:page]).per(10)
    respond_to do |format|
      format.html { render partial: 'contest/comments' }
      format.js
    end
  end

  def create_comment
    text = params[:comment]
    comment = Comment.new
    comment.text = text
    comment.user = current_user
    ccode = params[:ccode]
    pcode = params[:pcode]
    contest = Contest.by_code(ccode).first
    problem = contest.problems.by_code(pcode).first
    comment.problem = problem
    comment.save
    ccode = comment.problem.contest.ccode
    respond_to do |format|
      format.html { redirect_to problem_path(ccode, pcode), notice: 'Comment was successfully created.' }
      format.js   {}
    end
  end

  def get_snippet
    language = Language.where(lang_code: params['lang_code']).first
    msg = if language.nil? || !user_signed_in?
            { error: 'error loading' }
          else
            { snippet: language[:snippet] }
          end
    respond_to do |format|
      format.json { render json: msg }
    end
  end

  private

  def get_language_data(model, params = {})
    languages = []
    model.languages.map do |language|
      languages << if params[:name]
                     { name: language[params[:name].to_sym], code: language[params[:lang].to_sym] }
                   else
                     language[params[:lang].to_sym]
                   end
    end
    languages
  end
end
