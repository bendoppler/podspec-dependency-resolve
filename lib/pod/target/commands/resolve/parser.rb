require 'xcodeproj'
require 'tty-prompt'

module Pod
    module Target
        module Commands
            class Parser
                attr_reader :workspace, :workspace_dir, :regex
                def initialize(workspace_path, filter)
                    if workspace_path.nil?
                        prompt = TTY::Prompt.new
                        prompt.error("Error! Cannot find workspace path")
                        exit 1
                    end
                    @workspace_dir = File.dirname(workspace_path)
                    @workspace = Xcodeproj::Workspace.new_from_xcworkspace(workspace_path)
                    @regex = filter
                end

                def all_targets
                    @projects ||= projects
                    projects.flat_map(&:targets).select { |target| target.name =~ /#{regex}/ }
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