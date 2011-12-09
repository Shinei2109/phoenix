require "rubygems"
require "Phoenix/core/version"
require "thor"
require 'Phoenix/extension'

module Phoenix
  class CLI < Thor
    def self.basename
      "phoenix"
    end

    map "-v"        => "version"
    map "--version" => "version"

    desc "version", "print the current version"
    def version
      shell.say "Phoenix #{Phoenix.version}", :green
    end

    desc "extension NAME", "create a new extension with the given name"
    method_option "name", :type => :string
    def extension(name)
      invoke "phoenix:extension:generate", [options[:name] || name]
    end

    #desc "app NAME", "creates a new rails app configured to use Phoenix"
    #method_option "name", :type => :string
    #method_option "sample", :type => :boolean, :default => false
    #method_option "bootstrap", :type => :boolean, :default => false
    #method_option "clean", :type => :boolean, :default => false
    #method_option "dir", :type => :string, :default => '.'
    #def app(name)
      #invoke "Phoenix:application:generate", [options[:name] || name, options]
    #end

    #desc "sandbox", "create a sandbox rails app complete with sample data"
    #def sandbox(name="sandbox")
      #invoke "Phoenix:application:generate", [options[:name] || name, {:clean => true, :sample => true,
                                                                     #:bootstrap => true}]
    #end

    #desc "test_app", "create a rails app suitable for Phoenix testing"
    #method_option "dir", :type => :string, :default => '.'
    #def test_app(name="test_app")
      ##invoke "Phoenix:application:generate", [options[:name] || name, {:clean => true, :dir => options[:dir]}]
      #invoke "Phoenix:test:generate", [options[:dir]]
    #end
  end
end