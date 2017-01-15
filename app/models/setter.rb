class Setter
  include Mongoid::Document

  include Mongoid::Timestamps::Created::Short
  include ActiveModel::ForbiddenAttributesProtection

  has_one :user
  has_many :contests, dependent: :destroy
  has_many :problems, dependent: :destroy

  after_save :set_role

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
    self.user = User.by_id(id)
  end

  def set_role
    user = User.where(setter: self).first
    unless user.has_role? :admin
      user.roles = 'setter'
      user.save!
    end 
  end
end
