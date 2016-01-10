module UserTagsControllerConcern

  # POST
  #   Doc
  #     Quick add tags
  #
  #   Params
  #     auth_token:    string
  #     tag_name:      string
  def create
    current_user.send(tag_list_method).add(params[:tag_name])

    current_user.save!

    expose current_user.send(tags_method)
  end

  # POST
  #   Doc
  #     Used for syncing users liked tags
  #
  #   Params
  #     auth_token:    string
  #     tag_names:     array of tag names in a string format
  def sync
    current_user.send("#{tag_list_method}=", params[:tag_names])
    current_user.save
    expose current_user.send(tags_method)
  end

  # POST
  #   Doc
  #     Suggested tags
  #
  #   Params
  #     auth_token:    string
  def suggestions
    suggested_tags_finder = tags_finder_class.new(current_user)
    expose suggested_tags_finder.suggested_tags
  end

  private

  def tags_finder_class
    raise NotImplementedError
  end

  def tags_method
    raise NotImplementedError
  end

  def tag_list_method
    raise NotImplementedError
  end
end
