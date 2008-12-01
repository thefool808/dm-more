require 'rubygems'
gem 'rspec', '>=1.1.3'
require 'spec'
require 'pathname'

gem 'dm-core', '~>0.9.7'
require 'dm-core'

ADAPTERS = []
def load_driver(name, default_uri)

  lib = "do_#{name}"
  begin
    gem lib, '~>0.9.7'
    require lib
    DataMapper.setup(name, ENV["#{name.to_s.upcase}_SPEC_URI"] || default_uri)
    DataMapper::Repository.adapters[:default] =  DataMapper::Repository.adapters[name]
    ADAPTERS << name
  rescue Gem::LoadError => e
    warn "dm-contraints specs will not be run against #{name} - Could not load #{lib}: #{e}."
    false
  end
end

load_driver(:postgres, 'postgres://postgres@localhost/dm_core_test')
load_driver(:mysql,    'mysql://localhost/dm_core_test')

require Pathname(__FILE__).dirname.expand_path.parent + 'lib/dm-constraints'
