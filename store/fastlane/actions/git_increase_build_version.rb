require 'cfpropertylist'
module Fastlane
  module Actions
    class GitIncreaseBuildVersionAction < Action
      def self.run(params)
        plist = CFPropertyList::List.new(:file => 'store/Info.plist')
        data = CFPropertyList.native_types(plist.value)
        buildVersion = data['CFBundleVersion']
        version = data['CFBundleShortVersionString']
        sh 'git add .'
        sh "git commit -m \"[更新]Update Version #{version} Update build version #{buildVersion} \""
        sh "git push origin #{params[:branch]}"
      end

      def self.is_supported?(platform)
        true
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :branch,
                                       env_name: "GIT_BRANCH",
                                       description: "branch")
        ]
      end

    end
  end
end
