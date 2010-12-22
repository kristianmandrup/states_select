# States select

Based on [us_states plugin](http://svn.techno-weenie.net/projects/plugins/us_states/) by techno-weenie

This project has been extended to be available as either a plugin or a gem and is now targeting Rails 3.
The states selection has been made more flexible in order to support multiple countries and regions in the world (USA, Canada, ...). 
The select tag now takes a new :region option which currently supports the following:

* :usa
* :canada 
* :australia
* :india  

_Note:_ :usa is the default region if the :region option is not set.

Please help provide states for other regions/countries, fx EU, Africa, South America, ... 

_Note:_ 22 Dec. 2010

Currently this is mainly proof of concept and has not been fully tested. Testers wanted!

Following up on a suggestion by _asanghi_, I have added a generator to copy yml locale files for one or more "locales" (usa, canada, australia).
The gem now needs to be updated with an option to use these locale files instead of the hardcoded class methods.

## Locale files

To use the locale files use the :locale option instead of the region. 

<pre>
  <%= state_select 'child', 'state', :locale => :usa %> 
</pre>

You can even provide different locale translations and use the :lang option.
The following example should use the Chinese locale file of states for USA.

<pre>
  <%= state_select 'child', 'state', :locale => :usa, :lang => 'cn' %> 
</pre>
           
PS: Has not yet been tested!

## TODO

Add RSpec 2 tests, including use of *generator-spec* to test the generator and *rspec-action_view* to test the view helpers with various Form builders?. 

## Install in Rails 3 app

In Gemfile
<pre>
  gem 'states_select', '>= 1.0.1'
</pre>

In console/terminal:
<pre>
  $ bundle install  
</pre>

## Install as system gem

<pre>
  $ gem install states_select 
</pre>

## Install as plugin

$ rails install plugin http://github.com/kristianmandrup/states_select.git

Or something like that... (i.e install as gem is recommended)

## Usage

To select "priority" states that show up at the top of the list, call like so:
<pre>
  <%= state_select 'child', 'state', :priority => %w(TX CA) %> 
  <%= state_select 'child', 'state', :priority => %w(ON), :country => :canada %>   
</pre>

To select the way states display option and value:

this (default):
<pre>
<%= state_select 'child', 'state'%>   
</pre>

will yield this:
<pre>
  <option value="AK">Alaska</option>  
</pre>

this:
<pre>
  <%= state_select 'child', 'state', :show => :full %>   
</pre>

will yield this:
<pre>
  <option value="Alaska">Alaska</option>  
</pre>

Options are:

:full = <option value="Alaska">Alaska</option>
:full_abb = <option value="AK">Alaska</option>
:abbreviations = <option value="AK">AK</option>
:abb_full_abb = <option value="AK">AK - Alaska</option>
