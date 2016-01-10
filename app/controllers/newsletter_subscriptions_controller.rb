class NewsletterSubscriptionsController < ApplicationController
  respond_to :js, :html
  # protect_from_forgery except: :index

  def create
    @newsletter_subscription =
      NewsletterSubscription.create(newsletter_subscription_params)
  end

  private

  def newsletter_subscription_params
    params.require(:newsletter_subscription).permit(:email)
  end
end
