class UserController < ApplicationController
  def update
  	if current_user.username.blank? || current_user.college.blank?
  		redirect_to "/users/update_form"
  	else
  		redirect_to root_path
  	end
  end

  def update_form
  end

  def save_update
  	

  	current_user.update_attributes(:username => params[:username], 
  		:college => params[:college] , :name => params[:name])
  	flash[:notice] = "Welcome !!"
  	redirect_to root_path

  end

  def checkuser
    user = User.find_by_username(params[:username])
    respond_to do |format|
        format.json {render json: user}
    end
  end


  def profile
  	@user = []
    @user << {name: current_user.name,username: current_user.username,
              college: current_user.college}
  	submissions = current_user.submissions
    problems = submissions.where(status_code: 'AC').distinct(:problem)
    @solved_problem = []
    problems.each do |problem|
      p = Problem.where(_id: problem).first
      @solved_problem <<{contest_code: p.contest[:ccode],problem_code: p[:pcode] }
    end
  end

end
