require 'xcodeproj'

module Pod
    module Target
        module Commands
            class Parser
                attr_reader :workspace, :workspace_dir, :regex
                def initialize(workspace_path)
                    @workspace_dir = File.dirname(workspace_path)
                    @workspace = Xcodeproj::Workspace.new_from_xcworkspace(workspace_path)
                end

                def all_targets
                    @projects ||= projects
                    projects.flat_map(&:targets)
                end

                def projects
                    all_project_paths = @workspace.file_references.map(&:path)
                    all_project_paths.map do |project_path|
                        Xcodeproj::Project.open(File.expand_path(project_path, @workspace_dir))
                    end
                end
            end
        end
    end
end