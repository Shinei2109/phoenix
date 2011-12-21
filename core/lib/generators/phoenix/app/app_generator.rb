require 'rails/generators'
require 'rails/generators/rails/app/app_generator'
require 'rails/version'

module Phoenix
  class AppGenerator < Rails::Generators::AppBase

    source_root Pathname.new(File.expand_path('../templates', __FILE__))

    add_shared_options_for("Phoenix")

    class_option :force,          :type => :boolean, :aliases => ['-f'], :default => false,
                                  :desc => "Force overwriting of directory"

    class_option :gems,           :type => :array, :aliases => ['-g'],
                                  :desc => "Additional gems to install"

    class_option :confirm,        :type => :boolean, :aliases => ['-c'], :default => false,
                                  :desc => "Confirm any prompts that require input"

    class_option :testing,        :type => :boolean, :aliases => ['-t'], :default => true,
                                  :desc => "Automatically set up the project with phoenix-testing support"

    class_option :trace,          :type => :boolean, :default => false,
                                  :desc => "Investigate any problems with the installer"

    class_option :version,        :type => :boolean, :default => false,
                                  :desc => "Display the installed version of Phoenix Engine"

    class_option :skip_db,        :type => :boolean, :default => false,
                                  :desc => "Skip database creation and migration tasks"

    # Remove overridden or non-relevant class options
    remove_class_option(:skip_test_unit, :skip_bundle, :skip_gemfile, :skip_active_record, :skip_sprockets)

    TARGET_MAJOR_VERSION = 3
    TARGET_MINOR_VERSION = 1

    class << self
      def reserved_app_names
        @reserved_app_names ||= [
          'phoenix',
          'rails'
        ]
      end
    end

    def run!
      self.destination_root = app_path

      validate_options!
      generate_rails!
      prepare_gemfile!
      run_bundle

      rake('phoenix_core:install')
      rake('phoenix_auth:install')

      rake("db:migrate#{' --trace' if options[:trace]}")

      puts "\n---------"
      puts "Phoneinx successfully installed in '#{app_pathname}'!\n\n"

      heroku_deploy! if options[:heroku]

      note = ["\n=== ACTION REQUIRED ==="]
      if options[:skip_db]
        note << "Because you elected to skip database creation and migration in the installer"
        note << "you will need to run the following tasks manually to maintain correct operation:"
        note << "\ncd #{app_pathname}"
        note << "bundle exec rake db:create"
        note << "bundle exec rails generate phoenix:cms"
        note << "bundle exec rake db:migrate"
        note << "\n---------\n"
      end
      note << "Now you can launch your webserver using:"
      note << "\ncd #{app_pathname}"
      note << "rails server"
      note << "\nThis will launch the built-in webserver at port 3000."
      note << "You can now see your site running in your browser at http://localhost:3000"

      if options[:heroku]
        note << "\nIf you want files and images to work on heroku, you will need setup S3:"
        note << "heroku config:add S3_BUCKET=XXXXXXXXX S3_KEY=XXXXXXXXX S3_SECRET=XXXXXXXXXX S3_REGION=XXXXXXXXXX"
      end

      note << "\nThanks for installing Phoenix, enjoy creating your new application!"
      note << "---------\n\n"

      puts note.join("\n")
    end

    protected
      # Returns an instance of Pathname representing the required parameter app_path
      def app_pathname
        @app_pathname ||= Pathname.new(File.expand_path(app_path))
      end

      def validate_options!
        app_name = app_pathname.split.last.to_s

        unless valid_rails_version?
          puts "\nRails #{Rails::VERSION::STRING} is not supported by Phoenix #{Phoenix.version}, " \
               "please use Rails #{TARGET_MAJOR_VERSION}.#{TARGET_MINOR_VERSION}.x instead."
          exit(1)
        end

        unless valid_app_name?(app_name)
          puts "\nYou can't use '#{app_name}' as a name for your project, this is a reserved word that will cause conflicts."
          puts "Please choose another name for your new project."
          puts "\n"
          exit(1)
        end

        unless options[:force] || !app_pathname.directory?
          puts "\nThe directory '#{app_pathname}' that you specified already exists."
          puts "Use --force to overwrite an existing directory."
          puts "\n"
          exit(1)
        end

        if options[:heroku]
          if options[:heroku].to_s.include?('_') or options[:heroku].to_s.length > 30
            message = ["\nThe application name '#{options[:heroku]}' that you specified is invalid for Heroku."]
            suggested_name = options[:heroku].dup.to_s
            if suggested_name.include?('_')
              message << "This is because it contains underscores which Heroku does not allow."
              suggested_name.gsub!(/_/, '-')
            end
            if suggested_name.length > 30
              message << "This is#{" also" unless suggested_name.nil?} because it is longer than 30 characters."
              suggested_name = suggested_name[0..29]
            end

            if options[:force] || options[:confirm]
              options[:heroku] = suggested_name
            else
              message << "Please choose another name like '#{suggested_name}'"
              message << "Or use --confirm to automatically use '#{suggested_name}'"
              message << "\n"
              puts message.join("\n")
              exit(1)
            end
          end
        end
      end

      def generate_rails!
        rails_options = options.dup
        rails_options[:skip_test_unit] = true
        rails_options[:skip_bundle]    = true

        Rails::Generators::AppGenerator.new([app_path], rails_options).invoke_all

        if defined?(JRUBY_VERSION)
          find_and_replace('Gemfile', /['|"]sqlite3['|"]/, "'activerecord-jdbcsqlite3-adapter'")
        end

        # Remove rails from the Gemfile so that Phoenix can manage it
        find_and_replace('Gemfile', %r{^gem 'rails'}, "# gem 'rails'")
      end

      def prepare_gemfile!
        if options[:testing]
          gem 'phoenix_testing'
        end

        if options[:gems].present?
          options[:gems].each do |g|
            gem g
          end
        end
      end
      
    private

      def find_and_replace(file, find, replace)
        contents = app_pathname.join(file).read.gsub!(find, replace)
        app_pathname.join(file).open("w") do |f|
          f.puts contents
        end
      end

      def valid_rails_version?
        Rails::VERSION::MAJOR >= TARGET_MAJOR_VERSION && Rails::VERSION::MINOR >= TARGET_MINOR_VERSION
      end

      def valid_app_name?(app_name)
        self.class.reserved_app_names.exclude?(app_name.downcase)
      end
  end
end

# Yes, this is really how you set exit_on_failure to true in Thor.
module Rails
  module Generators
    class AppBase
      def self.exit_on_failure?
        true
      end
    end

    class AppGenerator
      def self.exit_on_failure?
        true
      end
    end
  end
end