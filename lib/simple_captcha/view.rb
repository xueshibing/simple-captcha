module SimpleCaptcha #:nodoc
  module ViewHelper #:nodoc

    # Simple Captcha is a very simplified captcha.
    #
    # It can be used as a *Model* or a *Controller* based Captcha depending on what options
    # we are passing to the method show_simple_captcha.
    #
    # *show_simple_captcha* method will return the image, the label and the text box.
    # This method should be called from the view within your form as...
    #
    # <%= show_simple_captcha %>
    #
    # The available options to pass to this method are
    # * label
    # * object
    #
    # <b>Label:</b>
    #
    # default label is "type the text from the image", it can be modified by passing :label as
    #
    # <%= show_simple_captcha(:label => "new captcha label") %>.
    #
    # *Object*
    #
    # This option is needed to create a model based captcha.
    # If this option is not provided, the captcha will be controller based and
    # should be checked in controller's action just by calling the method simple_captcha_valid?
    #
    # To make a model based captcha give this option as...
    #
    # <%= show_simple_captcha(:object => "user") %>
    # and also call the method apply_simple_captcha in the model
    # this will consider "user" as the object of the model class.
    #
    # *Examples*
    # * controller based
    # <%= show_simple_captcha(:label => "Human Authentication: type the text from image above") %>
    # * model based
    # <%= show_simple_captcha(:object => "person", :label => "Human Authentication: type the text from image above") %>
    #
    # Find more detailed examples with sample images here on my blog http://EXPRESSICA.com
    #
    # All Feedbacks/CommentS/Issues/Queries are welcome.
    #
    def show_simple_captcha(options={})
      defaults = {
         :image => simple_captcha_image,
         :label => options[:label] || I18n.t('simple_captcha.label'),
         :field => simple_captcha_field(options)
         }

      render :partial => 'simple_captcha/simple_captcha', :locals => { :simple_captcha_options => defaults }
    end

    def generate_simple_captcha_image(options={})
      simple_captcha_image
    end

    private

      def simple_captcha_image
        defaults = {}
        defaults[:_] = Time.now.to_i

        query = defaults.collect{ |key, value| "#{key}=#{value}" }.join('&')
        url = "#{ENV['RAILS_RELATIVE_URL_ROOT']}#{SimpleCaptcha.path}?#{query}"
        tag('img', :src => url, :alt => 'captcha')
      end

      def simple_captcha_field(options={})
        html = {:autocomplete => 'off', :required => 'required'}
        html.merge!(options[:input_html] || {})
        html[:placeholder] = options[:placeholder] || I18n.t('simple_captcha.placeholder')

        if options[:object]
          text_field(options[:object], :captcha, html.merge(:value => ''))
        else
          text_field_tag(:captcha, nil, html)
        end
      end
  end
end
