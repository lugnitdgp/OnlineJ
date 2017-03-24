class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:

    alias_action :read, :update, to: :modify
    alias_action :read, :update, :destroy, to: :change
    alias_action :create, :read, :update, :destroy, to: :crud

    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :setter
      can :access, :rails_admin
      # can :dashboard
      # can :read, :all
      can :read, Language
      can :modify, Contest, setter_id: (user.setter? ? user.setter.id : nil)
      can :read, Setter, id: (user.setter? ? user.setter.id : nil)
      cannot :index, Setter
      can :crud, Problem, setter_id: (user.setter? ? user.setter.id : nil)
      can :create, Announcement
      can :change, Announcement, Announcement.all do |announcement|
        announcement.contest.setter.try(:user) == user unless announcement.contest.nil?
      end
      can :create, TestCase
      can :change, TestCase, TestCase.all do |testcase|
        testcase.problem.setter.try(:user) == user unless testcase.problem.nil?
      end
      cannot :index, TestCase
      can [:read], Submission, Submission.all do |submission|
        submission.problem.setter.try(:user) == user || submission.try(:user) == user
      end
      can [:update, :destroy], Submission, Submission.all do |submission|
        submission.problem.setter.try(:user) == user
      end
    elsif user.has_role? :tester
      can [:read], Contest, Contest.all do |contest|
        user.testers.include? contest.tester
      end
      can [:read], Problem, Problem.all do |problem|
        user.testers.include? problem.tester
      end
      can :read, Submission, user_id: user.id
    else
      can :read, Submission, user_id: user.id
    end

    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
