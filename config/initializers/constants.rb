module Constants
  module Redis
    NAMESPACE = ENV['CONSTANTS_REDIS_NAMESPACE'].presence || 'gemicoma-development'
    HOST = ENV['CONSTANTS_REDIS_HOST'].presence || '127.0.0.1'
    PORT = ENV['CONSTANTS_REDIS_PORT'].blank? ? 16379 : ENV['CONSTANTS_REDIS_PORT'].to_i
  end
end
