class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:

    alias_action :read, :update, to: :modify
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
      can :crud, Problem, setter_id: (user.setter? ? user.setter.id : nil)
      can :crud, Announcement, Announcement.all do |announcement|
        announcement.contest.setter.try(:user) == user unless announcement.nil?
      end
      can :crud, TestCase, TestCase.all do |testcase|
        testcase.problem.setter.try(:user) == user unless testcase.nil?
      end
      can [:read], Submission, Submission.all do |submission|
        submission.problem.setter.try(:user) == user || submission.try(:user) == user
      end
      can [:update, :destroy], Submission, Submission.all do |submission|
        submission.problem.setter.try(:user) == user
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
