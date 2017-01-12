class ScoreboardController < ApplicationController
 def index
    @scoreboard_page = true
    contest = Contest.where({ccode: params[:ccode]}).first
    @ranklist = contest.ranklist
    @last_updated_at = @ranklist[:last_updated_time]
    @problems = contest.problems
    @contest_start_time = contest[:start_time]
    @user_array = @ranklist[:information]
    total_score = 0
    @user_array.each do |user|
      total_score += user[:total_score]
    end
    if total_score == 0
      flash[:notice] = "No submissions made to this contest yet"
      redirect_to contest_path
    end
  end
end
