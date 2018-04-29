module Constants
  module Redis
    NAMESPACE = ENV['CONSTANTS_REDIS_NAMESPACE'] || 'gemicoma-development'
    HOST = ENV['CONSTANTS_REDIS_HOST'] || '127.0.0.1'
    PORT = ENV['CONSTANTS_REDIS_PORT']&.to_i || 16379
  end
end
