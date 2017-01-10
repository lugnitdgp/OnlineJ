class Announcement
  include Mongoid::Document

  include Mongoid::Timestamps::Created::Short

  field :announcement,			type: String, default: ''

  belongs_to :contest
end
