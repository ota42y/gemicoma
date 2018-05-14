Redis.current = Redis::Namespace.new(
  ::Constants::Redis::NAMESPACE,
  redis: Redis.new(host: ::Constants::Redis::HOST, port: ::Constants::Redis::PORT),
)
