class ContestController < ApplicationController
  before_action :check
  def index
    @ccode = params[:ccode]
    contest = Contest.by_code(@ccode).first
    @title = contest[:cname]
    problems = contest.all_problems
    @Details = contest[:details]
    lang_data = []
    problems.each { |problem| lang_data << get_language_data(problem, name: 'name') }
    @problem_hash = { problems: problems, lang_data: lang_data }
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
      languages << if params[:lang]
                     { name: language[params[:name].to_sym], code: language[params[:lang].to_sym] }
                   else
                     language[params[:name].to_sym]
                   end
    end
    languages
  end

  
end
