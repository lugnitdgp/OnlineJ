class Setter
  include Mongoid::Document

  include Mongoid::Timestamps::Created::Short
  include ActiveModel::ForbiddenAttributesProtection

  has_one :user
  has_many :contests, dependent: :destroy
  has_many :problems, dependent: :destroy

  after_save :set_user
  after_destroy :remove_user

  validates :user, presence: true

  def to_s
    user
  end

  def title
    to_s
  end

  def user_id
    user.try :id
  end

  def user_id=(id)
    self.user = User.by_id(id).first
  end

  def set_user
    User.where(setter: self) do |u|
      u.setter_id = nil unless user == u
      # u.roles_mask = u.set_role
      u.save!
    end
  end

  def remove_user
    user.setter_id = nil
    # user.roles_mask = user.set_role
    user.save!
  end
end
