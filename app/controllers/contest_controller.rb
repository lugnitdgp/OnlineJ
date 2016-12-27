class ContestController < ApplicationController
  def index
    @ccode = params[:ccode]
    contest = Contest.by_code(@ccode).first
    @title = contest[:cname]
    @Problems = contest.all_problems
  end

  def problem
    @problem_page = true
    @pcode = params[:pcode]
    @Problem = Problem.where(pcode: @pcode, state: true).first
    @title = @Problem[:pname]
  end
end
