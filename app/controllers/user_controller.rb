class UserController < ApplicationController

  def update_form
    if user_signed_in?
      if current_user.username.blank? || current_user.college.blank?
        @user_page = true
        @user = []
        @user << { name: current_user.name, username: current_user.username, college: current_user.college }
      else
        redirect_to root_path
      end
    else
      redirect_to "/users/sign_in"
    end
  end

  def save_update
     if current_user.username.blank?
     current_user.update_attribute(:username,params[:username])
    end
    if current_user.college.blank?
     current_user.update_attribute(:college,params[:college])
    end
    if current_user.name.blank?
      current_user.update_attribute(:name,params[:name])
    end
    flash[:notice] = 'Welcome !!'
    redirect_to root_path
  end

  def checkuser
    username = params[:username]
    user = User.by_username(username).first
    data = {}
    data[:status] = if user.nil?
                      'OK You can go with that'
                    else
                      'Please try another username'
                    end
    respond_to do |format|
      format.json { render json: data }
    end
  end

  def profile
    @profile_page = true
    username = params[:username]
    puts username
    user = User.by_username(username).first
    @user = []
    @user << { name: user.name, username: user.username, college: user.college }
    submissions = user.submissions
    problems = submissions.where(status_code: 'AC').distinct(:problem)
    @solved_problem = []
    @solved_contest = []
    problems.each do |problem|
      p = Problem.find_by(_id: problem)
      @solved_problem << { contest_code: p.contest[:ccode], problem_code: p[:pcode] }
    end
  end
end
