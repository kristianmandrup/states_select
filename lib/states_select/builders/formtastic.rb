require 'states_select/builders/form_builder'

module Formtastic #:nodoc:
  class SemanticFormBuilder < ActionView::Helpers::FormBuilder
    def state_select(method, country_state_options = {}, options = {}, html_options = {})
      super
    end    
  end
end
