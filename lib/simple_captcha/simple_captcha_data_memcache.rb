module SimpleCaptcha
  class SimpleCaptchaData

    attr_accessor :value
    attr_reader :key

    def initialize(attributes={})
      @value = attributes[:value]
      @key   = attributes[:key]
      @memcache = SimpleCaptcha.memcache
    end

    def formated_key
      SimpleCaptcha::SimpleCaptchaData.formated_key(@key)
    end

    def save
      if valid?
        @memcache.write formated_key, @value, {:expires_in => SimpleCaptcha.expire}
      end
    end

    private
    def valid?
      @value.present? && @key.present?
    end

    class << self
      def formated_key(k)
        "#{SimpleCaptcha.memcache_namespace}#{k}"
      end

      def get_data(key)
        self.new key: key, value: SimpleCaptcha.memcache.read(formated_key(key))
      end

      def remove_data(key)
        SimpleCaptcha.memcache.delete self.formated_key(key)
      end

      def clear_old_data(time)
        raise StandardError.new("You shouldn't invoke this method to remove old data in memcache.")
      end
    end
  end
end
