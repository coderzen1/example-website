class DislikedSuggestedTagsFinder

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def suggested_tags
    ActiveRecord::Base.connection.execute(disliked_tags_of_other_users)
  end

  private

  def context
    :disliked_tags
  end

  def inverse_context
    :favorite_tags
  end

  def disliked_tag_ids
    "SELECT taggings.tag_id FROM taggings WHERE taggings.taggable_id = #{user.id} " \
                                           "AND taggings.taggable_type = 'User' " \
                                           "AND taggings.context = '#{context}'"
  end

  def liked_tag_ids
    "SELECT taggings.tag_id FROM taggings WHERE taggings.taggable_id = #{user.id} " \
                                           "AND taggings.taggable_type = 'User' " \
                                           "AND taggings.context = '#{inverse_context}'"
  end

  def ids_of_users_who_disliked_the_same_tags
    "SELECT taggings.taggable_id FROM taggings WHERE taggings.taggable_type = 'User' " \
                                                "AND context = '#{context}' " \
                                                "AND taggings.tag_id IN (#{disliked_tag_ids}) " \
                                                "AND taggings.taggable_id != #{user.id}"
  end

  def disliked_tags_of_other_users
    "SELECT taggings.tag_id AS id, tags.name, COUNT(*) FROM taggings " \
                                                "JOIN tags ON tags.id = taggings.tag_id " \
                                                "WHERE taggings.taggable_id IN (#{ids_of_users_who_disliked_the_same_tags}) " \
                                                "AND context = '#{context}' " \
                                                "AND taggable_type = 'User' " \
                                                "AND taggings.tag_id NOT IN (#{liked_tag_ids}) "\
                                                "AND taggings.tag_id NOT IN (#{disliked_tag_ids}) "\
                                                "GROUP BY taggings.tag_id, tags.name " \
                                                "ORDER BY COUNT DESC " \
                                                "LIMIT 10"
  end
end
# SELECT tag_id, COUNT(*) FROM taggings JOIN tags ON tags.id = taggings.tag_id WHERE tag_id IN (SELECT "taggings".tag_id FROM "taggings" INNER JOIN "tags" ON "tags"."id" = "taggings"."tag_id" WHERE "taggings"."taggable_id" = 1 AND "taggings"."taggable_type" = 'User' AND "taggings"."context" = 'favorite_tags') GROUP BY (tag_id) ORDER BY count DESC

