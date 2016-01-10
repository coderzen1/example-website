class AddNewsletterSubscription < ActiveRecord::Migration
  def change
    create_table :newsletter_subscriptions do |t|
      t.string :email
      t.integer :status, default: 0
      t.string :token

      t.timestamps
    end
  end
end
