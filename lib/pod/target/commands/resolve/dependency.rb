# frozen_string_literal: true

require_relative '../command'

module Pod
  module Target
    module Commands
      class Resolve::Dependency < Pod::Target::Command
        require 'resolve/xcworkspace'
        require 'resolve/parser'
        require 'resolve/graph'
        def initialize(options)
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
            @xcworkspace = options[:workspace]
            @xcworkspace ||= XCWorkspace.find_workspace
            @output = File.dirname(options[:ouput])
            @output ||= '.'
            @filter = options[:filter]
            @filter ||= '.*'
            run
          end
        end

        def run
          parser = Parser.new(@xcworkspace, @filter)
          targets = parser.all_tagets
          graph = new Graph()
          graph.add_target_info(targets)
          File.open("dependency.csv", "w") { |f| f.write "" }
          nodes = graph.nodes
          nodes.each do |key, value|
            File.open("dependency.csv", "a") { |f| f.write value.name }
            levelMap = {}
            graph.bfs(value, level_map, 0)
            value.neighbors.each do |neighbor|
              name = neighbor.name
              if level_map[:name] > 1
                File.open("dependency.csv", "a") { |f|
                  f.write "," + library_name
                }
              end
            end
          end
      end
    end
  end
end
