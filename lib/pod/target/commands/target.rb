# frozen_string_literal: true

require_relative '../command'
require 'tty-prompt'
require 'graphviz'

module Pod
  module Target
    module Commands
      class Target < Pod::Target::Command
        require_relative './resolve/xcworkspace'
        require_relative './resolve/parser'
        require_relative './resolve/graph'
        def initialize(options)
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          @xcworkspace = @options[:workspace]
          @xcworkspace ||= XCWorkspace.find_workspace
          @output = @options[:output]
          @output ||= '.'
          @root = @options[:root]
          if @root.nil?
            prompt = TTY::Prompt.new
            prompt.error("Root target is not set")
            exit 1
          end
          parse
        end

        def parse
          prompt = TTY::Prompt.new
          prompt.ok("Finding targets' dependencies and build graph...")
          parser = Parser.new(@xcworkspace, nil)
          targets = parser.all_targets
          graph = Graph.new
          graph.add_target_info(targets)
          dir = File.dirname(@output + "/dependencies.gv")
          tmp_file = File.join(dir, '/dependencies.gv')
          save_gv(graphviz_data(graph), tmp_file)
          graphviz_graph = GraphViz.parse(tmp_file)
          save_png(graphviz_graph, 'dependencies.png')
          FileUtils.remove_file(tmp_file)
          prompt.ok("File is write at: " + dir + "/dependencies.png")
        end

        def save_gv(graphviz_data, filename)
          graphviz_data.output(dot: filename)
        end

        def save_png(graphviz_data, filename)
          graphviz_data.output(png: filename)
        end

        def graphviz_data(graph)
          node = graph.nodes.values.find { |node| node.name =~ /#{@root}/ }
          unless  node.nil?
            graphviz = GraphViz.new(type: :digraph)
            level_map = {}
            graph.dfs2(node, level_map, 0)
            visited = Set.new([])
            dfs(graphviz, node, visited, level_map)
            graphviz
          end
        end

        def dfs(graphviz, node, visited, level_map)
          return if visited.include?(node.name)
          visited.add(node.name)
          depth = level_map[node.name]
          target_node = graphviz.add_node(node.name)
          node.neighbors.each do |dependency|
            if level_map[dependency.name] == depth+1
              dep_node = graphviz.add_node(dependency.name)
              graphviz.add_edge(target_node, dep_node)
              dfs(graphviz, dependency, visited, level_map)
            end
          end
        end
      end
    end
  end
end
