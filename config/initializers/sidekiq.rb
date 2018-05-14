Sidekiq.configure_server do |config|
  config.redis = {
    url: "redis://#{::Constants::Redis::HOST}:#{::Constants::Redis::PORT}",
    namespace: ::Constants::Redis::NAMESPACE,
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: "redis://#{::Constants::Redis::HOST}:#{::Constants::Redis::PORT}",
    namespace: ::Constants::Redis::NAMESPACE,
  }
end
