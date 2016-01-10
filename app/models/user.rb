class User < ActiveRecord::Base
  include CustomDeviseAuthenticable

  PROVIDERS = %w(twitter facebook instagram)

  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :photos, as: :owner

  has_many :favorites

  has_many :favorite_photos,
           source: :faved,
           source_type: 'Photo',
           through: :favorites

  has_many :favorite_restaurants,
           source: :faved,
           source_type: 'Restaurant',
           through: :favorites,
           counter_cache: true

  has_many :photo_reports, as: :reporter
  has_many :tag_reports, as: :reporter

  enum status: [:normal, :deleted, :locked]

  scope :deleted, -> { where(status: 1) }
  scope :flagged, -> { where(status: 0, flagged: true) }
  scope :normal, -> { where(status: 0, flagged: false) }

  validate :uid_and_provider_or_email_and_password
  validates :provider, inclusion: { in: PROVIDERS },
                       if: :uid_and_provider_present?

  before_save :generate_auth_token

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  mount_uploader :custom_profile_picture, AvatarUploader

  acts_as_taggable_on :favorite_tags, :disliked_tags

  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    following.include?(user)
  end

  def feed_ids
    following_ids.push(id)
  end

  def profile_picture
    return provider_profile_picture if provider && provider_profile_picture
    custom_profile_picture.small.url
  end

  private

    def email_required?
      provider.blank?
    end

    def password_required?
      super && provider.blank?
    end

    def generate_auth_token
      return if auth_token.present? || provider.present?
      loop do
        self.auth_token = Devise.friendly_token
        break if User.find_by_auth_token(auth_token).blank?
      end
    end

    def uid_and_provider_or_email_and_password
      # ^ is an XOR operation
      return if uid_and_provider_present? ^ email_and_password_present?
      errors.add(:base, "Either uid and provider, \
                 or email and pasword must be present.")
    end

    def uid_and_provider_present?
      uid.present? && provider.present?
    end

    def email_and_password_present?
      email.present? && (password.present? || encrypted_password.present?)
    end
end
