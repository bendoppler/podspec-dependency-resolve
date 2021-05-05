require 'xcodeproj'

module Pod
    module Target
        module Commands
            class XCWorkspace
                def self.find_workspace
                    `find . -name '*.xcworkspace' -maxdepth 1`.split("\n").first
                end
            end
        end
    end
end
    