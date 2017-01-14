class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
    end
    if not user.admin?
      can :read, Submission, user_id: user.id
    end
  end
end
