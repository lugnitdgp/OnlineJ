class UserController < ApplicationController
  def update_form
    if user_signed_in?
      if current_user.username.blank? || current_user.college.blank? || current_user.name.blank?
        @user_page = true
        @user = []
        @user << { name: current_user.name, username: current_user.username, college: current_user.college }
      else
        redirect_to root_path
      end
    else
      redirect_to '/users/sign_in'
    end
  end

  def save_update
    username = params[:username]
    user = User.by_username(username).first
    if user.nil? && !(username =~ /^[a-zA-Z0-9_]*$/).nil? && username.length > 1
      current_user.username = username
    end
    current_user.college = params[:college]
    current_user.name = params[:name]
    current_user.save!
    flash[:notice] = 'Welcome !!'
    redirect_to root_path
  end

  def checkuser
    username = params[:username]
    user = User.by_username(username).first
    data = {}
    data[:status] = if user.nil? && !(username =~ /^[a-zA-Z0-9_]*$/).nil?
                      'OK'
                    else
                      '500'
                    end
    respond_to do |format|
      format.json { render json: data }
    end
  end

  def profile
    @profile_page = true
    username = params[:username]
    user = User.by_username(username).first
    @name = user[:name]
    @username = user[:username]
    @college = user[:college]
    @image = user[:image]
    submissions = user.submissions
    @total_submissions = submissions.count
    problems = submissions.where(status_code: 'AC').distinct(:problem)
    @total_currect = problems.count
    solved_problem = []
    @solved = Hash.new { |hash, key| hash[key] = [] }
    problems.each do |problem|
      p = Problem.find_by(_id: problem)
      solved_problem << { contest_code: p.contest[:ccode], problem_code: p[:pcode] }
    end
    solved_problem.each do |problem|
      ccode = problem[:contest_code]
      pcode = problem[:problem_code]
      @solved[ccode.to_sym] << pcode
    end
  end

  def setLang
    lang_code = params[:default_language]
    language = Language.where( lang_code: lang_code).first
    msg = if language.nil?
            { error: 'True' }
          elsif current_user.default_language == lang_code
            { status: 'SET'  }
          else
            current_user.default_language = lang_code
            current_user.save
            { status: 'OK'}
          end
    respond_to do |format|
      format.json { render json: msg }
    end
  end
end
