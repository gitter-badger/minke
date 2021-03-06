module Minke
  module Commands
    class Swift
      def commands config
        {
          :build => {
            :get => [
              ['swift', 'build', '--fetch'],
              # ['bash','-c', "find /src/Packages/ -type d -name Tests -exec echo {} && rm -rf {} \\;"]
              ['bash','-c', "find /src/Packages/ -type d -name Tests | xargs rm -rf"]
            ],
            :build => [
              ['rm', '-rf', '.build'],
              ['swift', 'build', '-Xcc', '-fblocks','-Xlinker', '-rpath', '-Xlinker', '.build/debug']
            ],
            :test => [['swift', 'test']],
          },
          :docker => {
            :image => 'ibmcom/kitura-ubuntu:latest',
            :binds => ["#{source_directory}:/src"],
            :working_directory => "/src"
          }
        }
      end

      def source_directory
        Dir.pwd if File.exists?('Package.swift')
        File.expand_path('../.') if File.exists?('../Package.swift')
      end
    end
  end
end
