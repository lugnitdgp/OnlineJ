class Identity
  include Mongoid::Document

  field :uid,       type: String
  field :provider,  type: String
  belongs_to :user

  #function to find uid of the user if not then create new
  def self.find_for_oauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider)
  end

end
