# Hacker News popularity calculator
# This class is used to check if
# DiscoverScreenService is returning proper results
# FORMULA = (P-1) / (T+2) ^ G
class RatingCalculator

  attr_reader :photo

  def initialize(photo)
    @photo = photo
  end

  def score # use 10 decimal places just like in the SQL version
    ((rating - 1) / (created_hours_ago + 2) ** gravity).round(10)
  end

  def rating
    @rating ||= photo.favorites_count
  end

  def created_hours_ago
    @created_hours_ago ||= (Time.now - photo.created_at).to_i / 3600
  end

  def gravity
    DiscoverScreenService::GRAVITY
  end
end
