module CustomDeviseAuthenticable
  extend ActiveSupport::Concern

  included do
    validates :email, presence: true, if: :email_required?
    validates :email, uniqueness: { scope: :provider },
                      allow_blank: true,
                      if: :email_changed?
    validates :email, format: { with: email_regexp },
                      allow_blank: true,
                      if: :email_changed?

    validates :password, presence: true, if: :password_required?
    validates :password, confirmation: true, if: :password_required?
    validates :password, length: { within: password_length },
                         allow_blank: true
  end

  protected

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  module ClassMethods
    Devise::Models.config(self, :email_regexp, :password_length)
  end
end
