class HomeController < ApplicationController
  before_action :check
  def index
    @home_page = true
    upcoming_contests = Contest.upcomming
    running_contests = Contest.running
    past_contests = Contest.past
    @Contests = []
    @Contests << { name: 'Running Contests', data: running_contests, panel: 'success' }
    @Contests << { name: 'Upcoming Contests', data: upcoming_contests, panel: 'info' }
    @Contests << { name: 'Past Contests', data: past_contests, panel: 'default' }
  end
end
