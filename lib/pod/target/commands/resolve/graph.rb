require 'xcodeproj'

module Pod
    module Target
        module Commands
            class Graph
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

                def add_target_info(targets)
                    targets.each do |target|
                        dependency_names = find_dependencies(target)
                        node = node_for_target_display_name(target.display_name)
                        dependency_names.each do |dependency_name|
                            dependency_node = node_for_target_display_name(dependency_name)
                            add_neighbor(node, dependency_node)
                        end
                    end
                end

                def find_dependencies(target)
                    dependencies = target.dependencies
                    dependencies.map { |dependency| dependency.name }.compact
                end

                def node_for_target_display_name(display_name)
                    node = nodes[display_name]
                    if node.nil?
                        node = Node.new(display_name)
                        nodes[display_name] = node
                    end
                    node
                end

                def add_neighbor(source, destination)
                    source.add_neighbor(destination)
                end

                def bfs(node, level_map, depth)
                    return if depth == 3
                    name = node.name                    
                    if level_map.key?(name)
                        level_map[name] = [level_map[name], depth].max
                    else 
                        level_map[name] = depth
                    end
                    node.neighbors.each do |neighbor|
                        bfs(neighbor, level_map, depth+1)
                    end
                end
            end
        end
    end
end
