# frozen_string_literal: true

require 'thor'

module Pod
  module Target
    # Handle the application command line parsing
    # and the dispatch to various command objects
    #
    # @api public
    class CLI < Thor
      # Error raised by this runner
      Error = Class.new(StandardError)

      desc 'version', 'pod-target version'
      def version
        require_relative 'version'
        puts "v#{Pod::Target::VERSION}"
      end
      map %w(--version -v) => :version

      desc 'resolve-dependency', "Resolve dependencies of pod's targets"
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :workspace, type: :string,
                           desc: "Set workspace path, if not set will use current directory"
      method_option :output, type: :string,
                           desc: "Set output path of csv file, if not set will use current directory"
      def resolve_dependency(*)
        if options[:help]
          invoke :help, ['resolve-dependency']
        else
          require_relative 'commands/resolve/dependency'
          Pod::Target::Commands::Dependency.new(options).execute
        end
      end
    end
  end
end
