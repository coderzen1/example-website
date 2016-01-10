tags_hash = YAML.load_file('db/seeds/tags.yml')

tags_hash.each do |category, tags_in_category|
  category = TagCategory.create(name: category)

  tags_in_category.each do |tag|
    ActsAsTaggableOn::Tag.create(name: tag, category_id: category.id)
  end
end
