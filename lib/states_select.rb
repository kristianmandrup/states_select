require 'states_select/builders'

class StatesSelect
  class << self
    def states_for locale, options = {}
      load_states {:locale => locale}.merge(options)
    end

    protected
  
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
      require 'states_select/locales/usa'
      USA::States.names
    end

    def canada_states
      require 'states_select/locales/canada'
      Canada::Provinces.names
    end

    def australia_states
      require 'states_select/locales/australia'
      Australia::Provinces.names
    end

    def india_states
      require 'states_select/locales/india'
      India::States.names
    end

    def china_states
      require 'states_select/locales/china'
      China::Provinces.names
      puts "China provinces are not yet complete, please help ;)"
    end

    def locale_file name
      File.join(Rails.root, 'config', 'locales', name)
    end
  
    def load_locale name, lang = 'en'
      content = YAML::load locale_file "#{name}.#{lang}.yml")
      content[name]
    end
  end  
end

