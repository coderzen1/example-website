class NewsletterSubscription < ActiveRecord::Base
  enum status: [:active, :inactive]

  validates :email, presence: true,
                    uniqueness: true
  validates :token, uniqueness: true

  before_create :generate_unique_token

  private

  def generate_unique_token
    return if token.present?

    loop do
      self.token = Devise.friendly_token(32)
      break if NewsletterSubscription.find_by(token: token).blank?
    end
  end
end
