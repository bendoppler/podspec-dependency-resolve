require 'xcodeproj'

module Pod
    module Target
        module Commands
            class Resolve::XCWorkspace
                def self.find_workspace
                    `find . -name '*.xcworkspace' -maxdepth 1`.split("\n").first
                end
            end
        end
    end
end
    