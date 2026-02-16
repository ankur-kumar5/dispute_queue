class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  around_action :set_time_zone

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  rescue_from Pundit::NotAuthorizedError do
    redirect_to root_path, alert: "Access denied"
  end

  private

  def pundit_user
    Current.user
  end

  def set_time_zone(&block)
    Time.use_zone(Current.user&.time_zone || "UTC", &block)
  end
end

