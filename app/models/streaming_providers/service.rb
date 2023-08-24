class StreamingProviders::Service
  SECRET = "abcd".freeze

  def self.webhook_url(id, service)
    message = {event_id: id, type: service}
    key = ActiveSupport::MessageVerifier.new(SECRET).generate(message)
    Rails.application.routes.url_helpers.event_webhook_url(id: key)
  end

  def self.find_by_key(key)
    data = ActiveSupport::MessageVerifier.new(SECRET).verify(key)
    data.with_indifferent_access
  rescue
    nil
  end

  def self.process_by_key(key)
    data = find_by_key(key)
    return unless data

    mod = find_module_by_type(data[:type])
    mod.process(data) if mod
  end

  def self.find_module_by_type(type)
    case type
    when "jitsi"
      StreamingProviders::Jitsi
    when "whereby"
      StreamingProviders::Whereby
    when "mux"
      StreamingProviders::Mux
    when "zoom"
      StreamingProviders::Zoom
    when "restream"
      StreamingProviders::Restream
    when "twitch"
      StreamingProviders::Twitch
    when "stream_yard"
      StreamingProviders::StreamYard
    end
  end
end
