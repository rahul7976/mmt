module Cmr
  module Util
    # Times and logs execution of a block
    def self.time(logger, message, &block)
      start = Time.now
      result = yield
    ensure
      if message.is_a?(Proc)
        message.call(Time.now-start, result)
      else
        logger.info("#{message} [#{Time.now - start}s]")
      end
    end

    # checks if a token is an URS token
    def is_urs_token?(token)
      # URS token max length is 100, Launchpad token is much longer
      token.length <= 100 ? true : false
    end

    def truncate_token(token)
      return nil if token.nil?

      token_parts = token.split(':')
      if is_urs_token?(token_parts.first)
        token_parts.map { |token_part| token_part.truncate([token_part.length / 4 + 3, 8].max) }.join(':')
      else
        # launchpad tokens should not have a client_id
        token_parts.first.truncate(50)
      end
    end
  end
end
