task faker: :environment do
  # 10000.times do |x|
  #   User.create!(email: Faker::Internet.email,
  #                password: Faker::Internet.password(8))
  #   puts x
  # end

  # inserts = []
  # 5000.times do |x|
  #   inserts.push "('#{Faker::Internet.email}', '$2a$10$Ccb1WxBixr9Ax1rRG0RgHOitER03OvW68opU4XM8Pluw.ewFEQpmW', '2015-05-21 21:13:52.433579')"
  #   puts x
  # end
  # sql = "INSERT INTO users (email, encrypted_password, created_at) VALUES #{inserts.join(", ")}"
  # ActiveRecord::Base.connection.execute(sql)

  tag_ids = ActsAsTaggableOn::Tag.pluck(:id)

  User.where('id > ?', 3000).each_with_index do |user, index|
    puts index
    paritioned_tags = tag_ids.shuffle.in_groups(2)

    user.favorite_tag_ids = paritioned_tags.first.take(20)
    user.disliked_tag_ids = paritioned_tags.last.take(20)
    user.save!
  end

end
