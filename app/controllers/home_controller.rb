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

  def test
    unless user_signed_in?
      render(file: 'public/404.html', status: :not_found, layout: false) && return
    end
    @test = true
    myContests = nil
    if current_user.has_role? :setter
      myContests = Contest.myContests(current_user)
    elsif current_user.has_role? :admin
      myContests = Contest.all
    else
      render(file: 'public/404.html', status: :not_found, layout: false) && return
    end
    @Contests = []
    @Contests << { name: 'My Contests', data: myContests, panel: 'info' }
    render 'index'
  end
end
