class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable

  ## Database authenticatable
  field :email,              type: String, default: ''
  field :encrypted_password, type: String, default: ''

  ## Fields required
  field :username,           type: String, default: ''
  field :name,               type: String, default: ''
  field :college,            type: String, default: ''
  field :dob,                type: Date, default: ''

  ## roles for
  field :enable,             type: Boolean, default: ''
  field :admin,              type: Boolean, default: ''

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  has_many :identities
  has_and_belongs_to_many :contests
  belongs_to :setter
  has_many :submissions

  def self.find_for_oauth(auth, signed_user = nil)
    identity = Identity.find_for_oauth(auth)
    user = identity.user
    if user.nil?
      is_email = auth.info.email # && ( auth.info.verified || auth.info.verified_email)
      email = auth.info.email if is_email
      if signed_user.nil?
        user = User.where(email: email).first if email
      else
        user = signed_user
      end
      if user.nil?
        user = User.new
        user.fetch_details(auth)
        user.password = Devise.friendly_token[0, 20]
        user.skip_confirmation!
        user.save!
      end
      identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def fetch_details(auth)
    self.name = auth.info.name
    self.email = auth.info.email
    ## TODO add image for the user
    # self.photo = URI.parse(auth.info.image)
  end
end
