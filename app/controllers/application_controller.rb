class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_strava_user!
  before_action :redirect_to_previous_attempted_url

  private

  def authenticate_strava_user!
    unless current_user
      if request.get?
        session[:user_return_to] = request.original_fullpath
      elsif path = params[:return_to].presence
        session[:user_return_to] = path
      end
      redirect_to user_omniauth_authorize_path(provider: :strava)
    end
  end

  def redirect_to_previous_attempted_url
    if path = session.delete(:user_return_to).presence
      redirect_to path
    end
  end

  def flash_message type, text, now: false
    f = now ? flash.now : flash
    f[:messages] ||= {}
    f[:messages][type] = text
  end

  def track_event category:, action: , label: nil, value: nil, now: false
    f = now ? flash.now : flash
    f[:events] ||= []
    f[:events] << {
      'category'  => category,
      'action'    => action,
      'label'     => label,
      'value'     => value
    }
  end
end
