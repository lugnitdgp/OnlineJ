class ScoreboardController < ApplicationController
  def index
    @scoreboard_page = true
    @ccode = params[:ccode]
    contest = Contest.where(ccode: @ccode).first
    if contest.nil?
      render(file: 'public/404.html', status: :not_found, layout: false) && return
    end
    @cname = contest[:cname]
    @ranklist = contest.ranklist
    @last_updated_at = @ranklist[:last_updated_time]
    @problems = contest.problems
    @contest_start_time = contest[:start_time]
    @user_array = @ranklist[:information]
    if @user_array.nil?
      flash[:notice] = 'Ranklist is yet to be made, Please wait'
      redirect_to(contest_path(@ccode)) && return
    end
    total_score = 0
    @user_array.each do |user|
      total_score += user[:total_score]
    end
    if total_score == 0
      flash[:notice] = 'Ranklist is yet to be made, Please wait'
      redirect_to(contest_path(@ccode)) && return
    end
  end
end
