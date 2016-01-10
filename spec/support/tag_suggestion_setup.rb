module TagSuggestionSetup
  def setup_database_for_liked_tag_suggestions
    tags = create_list(:tag, 25)

    user.favorite_tags << tags.first
    second_user.favorite_tags << tags.first(15)
    third_user.favorite_tags << tags.first(2)

    user.disliked_tags << tags[3]
  end

  def setup_database_for_disliked_tag_suggestions
    tags = create_list(:tag, 25)

    user.disliked_tags << tags.first
    second_user.disliked_tags << tags.first(15)
    third_user.disliked_tags << tags.first(2)

    user.favorite_tags << tags[3]
  end
end
