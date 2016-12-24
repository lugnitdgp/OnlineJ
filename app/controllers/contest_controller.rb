class ContestController < ApplicationController
  def index
    @ccode = params[:ccode]
    @Contest = Contest.where({ ccode: @ccode, state: true}).first
    @Problems = @Contest.all_problems
  end
end
