class TagSearch
  SQL_QUERY = "SELECT id, name FROM tags WHERE (name ILIKE '%%%s%%')"

  def self.perform(query)
    new(query).perform
  end

  def initialize(query)
    @query = query
  end

  def perform
    return [] if query.blank?
    ActiveRecord::Base.connection.exec_query(sanitized_query)
  end

  private

  attr_reader :query

  def sanitized_query
    ActiveRecord::Base.send(:sanitize_sql_array, [SQL_QUERY, query])
  end
end
