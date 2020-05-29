require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "rn-socket-io"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  rn-socket-io
                   DESC
  s.homepage     = "https://github.com/shadyzpop/rn-socket-io"
  # brief license entry:
  s.license      = "MIT"
  # optional - use expanded license entry instead:
  # s.license    = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "shadyzpop" => "" }
  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://github.com/shadyzpop/rn-socket-io.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,c,m,swift}"
  s.requires_arc = true

	s.dependency "React"
	s.dependency "Socket.IO-Client-Swift"
  # ...
  # s.dependency "..."
end

