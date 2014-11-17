module SimpleCaptcha
  module FormBuilder
    def self.included(base)
      base.send(:include, SimpleCaptcha::ViewHelper)
      base.send(:include, SimpleCaptcha::FormBuilder::ClassMethods)
      base.send(:include, ActionView::Helpers)
      if defined? Sprokets
        base.send(:include, Sprockets::Rails::Helper)
      end

      base.delegate :render, :session, :to => :template
    end

    module ClassMethods
      # Example:
      # <% form_for :post, :url => posts_path do |form| %>
      #   ...
      #   <%= form.simple_captcha :label => "Enter numbers.." %>
      # <% end %>
      #
      def simple_captcha(options = {})
        options.update :object => @object_name
        show_simple_captcha(objectify_options(options))
      end

      private

        def template
          @template
        end

        def simple_captcha_field(options={})
          html = {:autocomplete => 'off', :required => 'required', :value => ''}
          html.merge!(options[:input_html] || {})
          html[:placeholder] = options[:placeholder] || I18n.t('simple_captcha.placeholder')

          text_field(:captcha, html)
        end

        def simple_captcha_image(simple_captcha_key, options = {})
          defaults = {}
          defaults[:time] = options[:time] || Time.now.to_i

          query = defaults.collect{ |key, value| "#{key}=#{value}" }.join('&')
          url = "#{ENV['RAILS_RELATIVE_URL_ROOT']}/simple_captcha?code=#{simple_captcha_key}&#{query}"
          tag('img', :src => url, :alt => 'captcha') +
          hidden_field(:captcha_key, :value => options[:field_value])
        end
    end
  end
end
