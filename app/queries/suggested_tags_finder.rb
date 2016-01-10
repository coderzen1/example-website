class SuggestedTagsFinder
  def self.for(user, liked: true)
    if liked
      LikedSuggestedTagsFinder.new(user)
    else
      DislikedSuggestedTagsFinder.new(user)
    end
  end
end
