require 'rails_helper'

describe NewsletterSubscription do
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }

  it { should validate_uniqueness_of :token }

  it { should define_enum_for :status }

  it "should create a token after creating a subscription" do
    subscription = NewsletterSubscription.create(email: "test@infinum.hr")

    subscription.reload

    expect(subscription.token).to_not be_blank
  end

  it "should not set a new token if there is one already set" do
    subscription =
      NewsletterSubscription.create(email: "test@infinum.hr",
                                    token: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    subscription.reload

    expect(subscription.token).to eq("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
  end

  context "the status field" do
    it "should be 0 by default" do
      subscription =
        NewsletterSubscription.create(email: "test@infinum.hr",
                                      token: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")

      expect(subscription.status).to eq("active")
    end
  end
end
