class Setter
  include Mongoid::Document

  include Mongoid::Timestamps::Created::Short

  has_one :user
  has_many :contests, dependent: :destroy
  has_many :problems, dependent: :destroy
end
