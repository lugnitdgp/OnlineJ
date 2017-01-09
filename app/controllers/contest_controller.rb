class ContestController < ApplicationController
  before_action :check
  def index
    @ccode = params[:ccode]
    contest = Contest.by_code(@ccode).first
    if contest.nil?
      render(file: 'public/404.html', status: :not_found, layout: false) && return
    end
    @title = contest[:cname]
    problems = contest.all_problems
    @Details = contest[:details]
    lang_data = []
    success_sub = []
    problems.each { |problem| lang_data << get_language_data(problem, lang: 'lang_code') }
    problems.each { |problem| success_sub << problem.submissions.where(status_code: 'AC').count }
    @problem_hash = { problems: problems, lang_data: lang_data, success_sub: success_sub }
  end

  def problem
    @problem_page = true
    @ccode = params[:ccode]
    @pcode = params[:pcode]
    problem = Problem.by_code(@pcode).first
    @title = problem[:pname]
    @statement = problem[:statement]
    @setter_name = problem.setter.user[:name]
    @setter_username = problem.setter.user[:username]
    @language_hash = get_language_data(problem, name: 'name', lang: 'lang_code')
    @score = problem[:max_score]
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
