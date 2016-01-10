class PublicController < ApplicationController
  def index
    @newsletter_subscription = NewsletterSubscription.new
  end

  def about
  end

  def privacy_policy
  end

  def terms_of_use
  end
end
