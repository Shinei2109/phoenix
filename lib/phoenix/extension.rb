module Phoenix
  class Extension < Thor
    include Thor::Actions

    def self.source_root
      File.dirname(__FILE__) + '/templates/extension'
    end

    desc "generate NAME", "generate extension"
    def generate(name)

      class_path = name.include?('/') ? name.split('/') : name.split('::')
      class_path.map! { |m| m.underscore }
      self.proj_name = name
      self.file_name = 'phoenix_' + class_path.pop.gsub('phoenix_', '')
      self.human_name = name.titleize
      self.class_name = file_name.classify

      empty_directory file_name

      directory "app", "#{file_name}/app"

      empty_directory "#{file_name}/app/controllers/phoenix"
      empty_directory "#{file_name}/app/helpers/phoenix"
      empty_directory "#{file_name}/app/models/phoenix"
      empty_directory "#{file_name}/app/views/phoenix"
      empty_directory "#{file_name}/app/overrides"

      directory "lib", "#{file_name}/lib"
      directory "script", "#{file_name}/script"

      empty_directory "#{file_name}/spec"

      template "Rakefile", "#{file_name}/Rakefile"
      template "README.md", "#{file_name}/README.md"
      template "gitignore", "#{file_name}/.gitignore"
      template "extension.gemspec", "#{file_name}/#{file_name}.gemspec"
      template "Versionfile", "#{file_name}/Versionfile"
      
      directory "config", "#{file_name}/config"

      template "Gemfile", "#{file_name}/Gemfile" unless integrated
      template "spec_helper.rb.tt", "#{file_name}/spec/spec_helper.rb"
      template "rspec", "#{file_name}/.rspec"

      if integrated
        append_to_file(gemfile) do
          "\ngem '#{file_name}', :path => '#{file_name}'"
        end
      end
    end

    no_tasks do
      # File/Lib Name (ex. phoenix_paypal_express)
      attr_accessor :file_name
    end

    no_tasks do
      # File/Lib Name without Phoenix (ex. paypal_express)
      attr_accessor :proj_name
    end
    
    no_tasks do
      # Human Readable Name (ex. Paypal Express)
      attr_accessor :human_name
    end

    no_tasks do
      # Class Name (ex. PaypalExpress)
      attr_accessor :class_name
    end

    protected
    def gemfile
      File.expand_path("Gemfile", Dir.pwd)
    end
    
    # extension is integrated with an existing rails app (as opposed to standalone repository)
    def integrated
      File.exist?(gemfile)
    end
  end
end