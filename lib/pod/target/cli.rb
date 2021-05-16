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

      desc 'target', 'Find dependencies of the target'
      method_option :root, type: :string,
                    desc: 'Set name of the root target, must be set'
      method_option :workspace, type: :string,
                    desc: "Set workspace path, if not set will use current directory"
      method_option :output, type: :string,
                    desc: "Set output path of csv file, if not set will use current directory"
      def target(*)
        require_relative 'commands/target'
        Pod::Target::Commands::Target.new(options).execute
      end

      desc 'resolve-dependency', "Resolve dependencies of pod's targets"
      method_option :workspace, type: :string,
                           desc: "Set workspace path, if not set will use current directory"
      method_option :output, type: :string,
                           desc: "Set output path of csv file, if not set will use current directory"
      method_option :filter, type: :string, banner: "expression",
                          desc: "If set, filter targets which name matches the regular expression"
      def resolve_dependency(*)
        require_relative 'commands/dependency'
        Pod::Target::Commands::Dependency.new(options).execute
      end
    end
  end
end
