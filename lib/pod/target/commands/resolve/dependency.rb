# frozen_string_literal: true

require_relative '../../command'
require 'tty-prompt'

module Pod
  module Target
    module Commands
      class Dependency < Pod::Target::Command
        require_relative './xcworkspace'
        require_relative './parser'
        require_relative './graph'
        def initialize(options)
          @options = options
        end

        def execute
            @xcworkspace = @options[:workspace]
            @xcworkspace ||= XCWorkspace.find_workspace
            @output = @options[:output]
            @output ||= '.'
            @filter = @options[:filter]
            @filter ||= '.*'
            parse
        end

        def parse
          prompt = TTY::Prompt.new
          prompt.ok("Finding targets' dependencies and resolving them...")
          parser = Parser.new(@xcworkspace, @filter)
          targets = parser.all_targets
          graph = Pod::Target::Commands::Graph.new
          graph.add_target_info(targets)
          directory = File.join(File.dirname(@output + "/remove_dependency.csv"),"/remove_dependency.csv")
          File.open(directory, "w") { |f| f.write "" }
          nodes = graph.nodes
          nodes.each do |_, value|
            level_map = {}
            graph.bfs(value, level_map, 0)
            removes = []
            value.neighbors.each do |neighbor|
              if level_map[neighbor.name] > 1
                removes << neighbor.name

              end
            end
            if removes.size > 0
              File.open(directory, "a") { |f| f.write value.name }
              removes.each { |name|
                File.open(directory, "a") { |f|
                  f.write "," + name
                }
              }
              File.open(directory, "a") { |f|
                f.write "\n"
              }
            end
          end
          prompt.ok("File is write at: " + directory)
        end
      end
    end
  end
end
