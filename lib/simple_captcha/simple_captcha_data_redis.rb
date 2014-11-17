module SimpleCaptcha
  class SimpleCaptchaData

    attr_accessor :value
    attr_reader :key

    def initialize(attributes={})
      @value = attributes[:value]
      @key   = attributes[:key]
      @redis = SimpleCaptcha.redis
    end

    def save
      if valid?
        @redis.set @key, @value
        @redis.expire @key, SimpleCaptcha.expire
      end
    end

    private
    def valid?
      @value.present? && @key.present?
    end

    class << self
      def get_data(key)
        self.new key: key, value: SimpleCaptcha.redis.get(key)
      end

      def remove_data(key)
        SimpleCaptcha.redis.del key
      end

      def clear_old_data(time)
        raise StandardError.new("You shouldn't invoke this method to remove old data in redis.")
      end
    end
  end
end
