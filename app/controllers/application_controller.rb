require "application_responder"

class ApplicationController < ActionController::Base
  include ActionView::Helpers::AssetUrlHelper

  include ApplicationHelper
  before_action :get_meta_tags

  self.responder = ApplicationResponder
  respond_to :html, :js

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # before_action :redirect_signed_in

  private

  def redirect_signed_in
    redirect_to restaurant_root_path if restaurant_owner_signed_in?
  end

  def get_meta_tags
    set_meta_tags(meta_tag_options)
  end
end
