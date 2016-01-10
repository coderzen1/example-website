task import_photos: :environment do
  restaurant = Restaurant.find(4752)
  user = User.find_by(email: 'jackdaniels@c.co')

  Dir[File.join(Rails.root, 'lib', 'tasks', 'photos', '*')].each do |photo_path|
    photo =
      Photo.new(owner: user, restaurant: restaurant, caption: 'Hamburgersss')

    File.open(photo_path) do |f|
      photo.image = f
    end

    photo.save!
  end
end
