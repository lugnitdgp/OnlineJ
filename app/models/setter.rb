class Setter
  include Mongoid::Document

  include Mongoid::Timestamps::Created::Short

  has_many :users
  has_many :contests, dependent: :destroy
  has_many :problems, dependent: :destroy
end
