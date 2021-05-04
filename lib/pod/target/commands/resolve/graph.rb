require 'xcodeproj'

module Pod
    module Target
        module Commands
            class Resolve::Graph
                class Node
                    attr_accessor :name
                    attr_accessor :neighbors

                    def initialize(name)
                        self.name = name
                        self.neighbors = []
                    end

                    def add_neighbor(node)
                        neighbors << node
                    end
                end
                attr_accessor :nodes
                def initialize
                    @nodes = {}
                end
                def add_target_info(target_names)
                    target_names.map { |name|
                        dependency_names = find_dependencies(name)
                        node = node_for_target_display_name(name)
                        dependency_names.each do |name|
                            dependency_node = node_for_target_display_name(name)
                            add_neighbor(node, dependency_node)
                        end
                    }
                end

                def find_dependencies(target)
                    dependencies = target.dependencies
                    dependencies.filter_map { |dependency| dependency.name }
                end

                def node_for_target_display_name(display_name)
                    node = nodes[display_name]
                    if node.nil?
                        node = Node.new(display_name)
                        nodes[display_name] = node
                    end
                    return node
                end

                def add_neighbor(source, destination)
                    source.add_neighbor(destination)
                end

                def bfs(node, level_map, depth)
                    if depth == 3
                        return
                    name = node.name
                    end
                    if level_map.key?(node.name)
                        level_map[name] = [level_map[:name], depth].max
                    else 
                        level_map[name] = depth
                        node.neighbors.each do |neighbor| 
                            bfs(neighbor, depth+1, level_map)
                    end
                end
            end
        end
    end
end