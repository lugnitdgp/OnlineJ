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
  field :image,              type: String, default: ''

  ## roles for
  field :enable,             type: Boolean, default: ''
  field :roles_mask,         type: Integer, default: ''

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
  belongs_to :setter, optional: true
  has_many :submissions

  index({ username: 1 }, unique: false)

  scope :by_id, ->(id) { where(_id: id) }
  scope :by_username, ->(username) { where(username: username) }

  before_save :create_user_data
  after_destroy :delete_user_data
  before_create :first_user_admin

  def to_s
    username
  end

  def title
    to_s
  end

  ROLES = %i(admin setter).freeze

  def roles=(roles)
    roles = [*roles].map(&:to_sym)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask.to_i || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def has_role?(role)
    roles.include?(role)
  end

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
      if identity.user != user
        identity.user = user
        identity.save!
      end
    end
    user
  end

  def fetch_details(auth)
    self.name = auth.info.name
    self.email = auth.info.email
    self.image = URI.parse(auth.info.image)
  end

  private

  def first_user_admin
    self.roles = 'admin' if 'User'.constantize.count == 0
  end

  def create_user_data
    system 'mkdir', '-p', "#{CONFIG[:base_path]}/#{self[:email]}"
    true
  end

  def delete_user_data
    system 'rm', '-rf', "#{CONFIG[:base_path]}/#{self[:email]}"
    true
  end
end
