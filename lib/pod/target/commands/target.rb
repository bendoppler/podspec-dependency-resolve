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
          @max_depth = @options[:max_depth]
          @max_depth ||= -1
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
          file = File.join(dir, '/' + @root + '-dependencies.png')
          save_png(graphviz_graph, file)
          FileUtils.remove_file(tmp_file)
          prompt.ok("File is write at: " + dir + "/" + @root + "-dependencies.png")
        end

        def save_gv(graphviz_data, filename)
          graphviz_data.output(dot: filename)
        end

        def save_png(graphviz_data, filename)
          graphviz_data.output(png: filename)
        end

        def graphviz_data(graph)
          node = graph.nodes.values.find { |node| node.name == @root }
          if node.nil?
            prompt = TTY::Prompt.new
            prompt.error("Cannot find root target")
            exit 1
          else
            graphviz = GraphViz.new(type: :digraph)
            parent = {}
            dfs(graphviz, node, graph, parent, 0)
            graphviz
          end
        end

        def dfs(graphviz, node, graph, parent, depth)
          if @max_depth != -1 && depth == @max_depth
            return
          end
          target_node = graphviz.add_node(node.name)
          level_map = {}
          graph.dfs(node, level_map, 0)
          node.neighbors.each do |dependency|
            if level_map[dependency.name] == 1
              if parent.key?(dependency.name) == false
                parent[dependency.name] = Set.new
              end
              if parent[dependency.name].include?(node.name) == false
                parent[dependency.name].add(node.name)
                dep_node = graphviz.add_node(dependency.name)
                graphviz.add_edge(target_node, dep_node)
                dfs(graphviz, dependency, graph, parent, depth+1)
              end
            end
          end
        end
      end
    end
  end
end
