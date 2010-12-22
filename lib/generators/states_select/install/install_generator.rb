require 'rails3_artifactor'
require 'logging_assist'

module StatesSelect
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Configures Rails app for use with States Select"

      argument :names, :type => :array, :default => ['usa'], :desc => 'Regions/Countries to generate state/province locale files for'

      source_root File.dirname(__FILE__) + '/templates'

      def main_flow      
        copy_locales
      end
  
      protected

      include Rails3::Assist::BasicLogger
      # extend Rails3::Assist::UseMacro

      def locale_names
        names.select{|n| valid_locales.include? n }
      end
      
      def valid_locales
        [:usa, :canada, :australia, :india, :china]
      end
  
      def copy_locales
        locale_names.each do |loc|  
          template "#{loc}.yml", "config/locales/#{loc}.en.yml"
        end
      end
    end
  end
end