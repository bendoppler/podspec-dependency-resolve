require 'xcodeproj'

module Pod
    module Target
        module Commands
            class Resolve::Parser
                def initialize(workspace_path, filter)
                    @workspace_dir = File.dirname(workspace_path)
                    @workspace = Xcodeproj::Workspace.new_from_xcworkspace(workspace_path)
                    @regex = filter
                    @regex ||= '.*'
                end

                def all_tagets
                    @projects ||= projects
                    projects.filter_map(&:targets) { |target| target.name =~ /#{regex}/ }
                end

                def projects
                    all_project_paths = workspace.file_references.map(&:path)
                    all_project_paths.map do |project_path|
                        Xcodeproj::Project.open(File.expand_path(project_path, @workspace_dir))
                    end
                end
            end
        end
    end
end