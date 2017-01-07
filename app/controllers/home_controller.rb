class HomeController < ApplicationController
  before_action :check
  def index
    upcoming_contests = Contest.upcomming
    running_contests = Contest.running
    past_contests = Contest.past
    @Contests = []
    @Contests << { name: "Upcoming Contests" , data: upcoming_contests }
    @Contests << { name: "Running Contests", data: running_contests }
    @Contests << { name: "Past Contests", data: past_contests }
  end

  def check
    if user_signed_in? && current_user.username.blank?
      redirect_to force_update_url
    end
  end
end
