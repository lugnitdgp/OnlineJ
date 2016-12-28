class Setter
  include Mongoid::Document

  include Mongoid::Timestamps::Created::Short
  include ActiveModel::ForbiddenAttributesProtection

  has_one :user
  has_many :contests, dependent: :destroy
  has_many :problems, dependent: :destroy

  def user_id
    self.user.try :id
  end

  def user_id=(id)
    self.user = User.find_by_id(id)
  end

end
