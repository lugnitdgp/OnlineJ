class Tester
  include Mongoid::Document
  has_and_belongs_to_many :users
  has_many :contests
  has_many :problems

  after_save :set_role
  after_destroy :remove_user

  def set_role
    users.each do |user|
      user.save!
    end
  end

  def remove_user
    users.each do |user|
      user.tester_ids.delete(_id)
      user.save!
    end
  end
end
