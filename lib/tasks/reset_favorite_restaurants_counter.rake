task reset_favorite_restaurants_counter: :environment do
  user_ids = User.pluck(:id)

  user_ids.each do |user_id|
    favorited_restaurant_count =
      Favorite.where(user_id: user_id, faved_type: "Restaurant").count

    User.update_counters(
      user_id, favorite_restaurants_count: favorited_restaurant_count
    )
  end
end
