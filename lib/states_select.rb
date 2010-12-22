module ActionView
  module Helpers
    module FormOptionsHelper
      def state_options_for_select(selected = nil, country_state_options = {})
        state_options      = ""
        priority_states    = lambda { |state| country_state_options[:priority].include?(state.last) }
        country_state_options[:show] = :full if country_state_options[:with_abbreviation]
                
        country_states = load_states country_state_options
        
        states_label = case country_state_options[:show]
          when :full_abb          then lambda { |state| [state.first, state.last] }
          when :full              then lambda { |state| [state.first, state.first] }
          when :abbreviations     then lambda { |state| [state.last, state.last] }
          when :abb_full_abb      then lambda { |state| ["#{state.last} - #{state.first}", state.last] }
          else                         lambda { |state| state }
        end

        if country_state_options[:include_blank]
          if country_state_options[:include_blank].class == TrueClass
            state_options += "<option value=\"\">--</option>\n"
          else
            state_options += "<option value=\"\">#{country_state_options[:include_blank].to_s}</option>\n"
          end
        end

        if country_state_options[:priority]
          state_options += options_for_select(country_states.select(&priority_states).collect(&states_label), selected)
          state_options += "<option value=\"\">--</option>\n"
        end

        if country_state_options[:priority] && country_state_options[:priority].include?(selected)
          state_options += options_for_select(country_states.reject(&priority_states).collect(&states_label), selected)
        else
          state_options += options_for_select(country_states.collect(&states_label), selected)
        end

        return state_options
      end

      def state_select(object, method, country_state_options = {}, options = {}, html_options = {})
        InstanceTag.new(object, method, self, options.delete(:object)).to_state_select_tag(country_state_options, options, html_options)
      end

      private

      def load_states country_state_options = {}
        lang = country_state_options[:lang] || 'en'        
        country = country_state_options[:region] || country_state_options[:locale] || :usa
        begin
          return load_locale country, lang if country_state_options[:locale]
          send :"#{country}_states"
        rescue
          raise ArgumentError, "Country #{country} is not currently supported for this state plugin"
        end
      end
      
      def usa_states
        require 'states_select/usa'
        USA::States.names
      end

      def canada_states
        require 'states_select/canada'
        Canada::Provinces.names
      end

      def australia_states
        require 'states_select/australia'
        Australia::Provinces.names
      end

      def locale_file name
        File.join(Rails.root, 'config', 'locales', name)
      end
      
      def load_locale name, lang = 'en'
        content = YAML::load locale_file "#{name}.#{lang}.yml")
        content[name]
      end
    end

    class InstanceTag #:nodoc:
      # lets the us_states plugin handle Rails 1.1.2 AND trunk
      def value_with_compat(object=nil)
        if method(:value_without_compat).arity == 1
          value_without_compat(object)
        else
          value_without_compat
        end
      end
      alias_method :value_without_compat, :value
      alias_method :value, :value_with_compat

      def to_state_select_tag(country_state_options, options, html_options)
        html_options = html_options.stringify_keys
        add_default_name_and_id(html_options)
        content_tag("select", add_options(state_options_for_select(value(object), country_state_options), options, value(object)), html_options)
      end
    end
    
    class FormBuilder
      def state_select(method, country_state_options = {}, options = {}, html_options = {})
        @template.state_select(@object_name, method, country_state_options, options.merge(:object => @object), html_options)
      end
    end
  end
end
