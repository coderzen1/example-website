require 'rails_helper'

describe NewsletterSubscriptionsController do
  let(:email) { "test-email@infinum.hr" }

  describe "POST #create" do
    context "when sending correct params" do
      it "create a new newsletter" do
        expect do
          xhr :post,
              :create,
              newsletter_subscription: { email: "test-email@infinum.hr" }
        end.to change(NewsletterSubscription, :count).by(1)
      end

      it "should return success" do
        xhr :post,
            :create,
            newsletter_subscription: { email: "test-email@infinum.hr" }

        expect(response).to render_template(:create)
      end
    end

    context "when sending incorrect params" do
      it "should not create a new newsletter" do
        expect do
          xhr :post,
              :create,
              newsletter_subscription: { email: "" }
        end.not_to change(NewsletterSubscription, :count)
      end

      it "should return 422" do
        xhr :post,
            :create,
            newsletter_subscription: { email: "" }

        expect(response).to render_template(:create)
      end
    end
  end
end
