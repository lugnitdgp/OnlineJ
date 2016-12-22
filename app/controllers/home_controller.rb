require 'bson'
Moped::BSON = BSON

class HomeController < ApplicationController
  def index
    upcoming_contests = Contest.where(start_time: { :$gt => DateTime.now })
    running_contests = Contest.where(start_time: { lte: DateTime.now }, end_time: { gte: DateTime.now })
    past_contests = Contest.where(end_time: { lt: DateTime.now })
    @Contests = []
    @Contests << { name: "Upcoming Contests" , data: upcoming_contests }
    @Contests << { name: "Running Contests", data: running_contests }
    @Contests << { name: "Past Contests", data: past_contests }
  end
end
