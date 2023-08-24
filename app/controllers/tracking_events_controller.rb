require "browser"

class TrackingEventsController < ApplicationController
  def show
    remote_ip = request.remote_ip

    location_data = Geocoder.search(remote_ip).first
    city = location_data&.city || nil
    country = location_data&.country || nil

    track = Track.find(params[:track_id])
    ua = request.user_agent

    browser = Browser.new(ua)

    options = {
      remote_ip: remote_ip,
      country: country,
      city: city,
      ua: ua,
      lang: request.headers["HTTP_LANG"] || "en",
      referer: request.headers["HTTP_REFERER"],
      utm_medium: params[:utm_medium],
      utm_source: params[:utm_source],
      utm_campaign: params[:utm_campaign],
      utm_content: params[:utm_content],
      utm_term: params[:utm_term],
      browser_name: browser.name,
      browser_version: browser.version,
      modern: modern_browser?(browser),
      platform: browser.platform.to_s,
      device_type: browser.device.name,
      bot: browser.bot?,
      search_engine: browser.bot.search_engine?,
      track_id: track.id,
      # session_id: "session_id", # replace this with your actual session_id logic
      user_id: current_user&.id,
      resource_profile_id: track.user_id,
      created_at: DateTime.now.utc,
      updated_at: DateTime.now.utc
    }

    # event = Event.new(options)

    # Assuming WriteBuffer.insert is your custom way to save events
    # WriteBuffer.insert(event)

    track.listening_events.create(options)

    render json: options, status: :ok
  end

  private

  def modern_browser?(browser)
    [
      browser.chrome?(">= 65"),
      browser.safari?(">= 10"),
      browser.firefox?(">= 52"),
      browser.ie?(">= 11") && !browser.compatibility_view?,
      browser.edge?(">= 15"),
      browser.opera?(">= 50"),
      browser.facebook? && browser.safari_webapp_mode? && browser.webkit_full_version.to_i >= 602
    ].any?
  end
end
