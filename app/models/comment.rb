class Comment
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short

  field :text,		type: String

  belongs_to :problem
  belongs_to :user

end
