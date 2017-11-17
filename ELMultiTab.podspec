Pod::Spec.new do |s|
  s.name             = "ELMultiTab"
  s.version          = "1.0.1"
  s.summary          = "A multi-tab user interface"
  s.description      = <<-DESC
A multi-tab user interface like a desktop web browser
                       DESC

  s.homepage         = "https://github.com/eddy-lau/ELMultiTab"
  s.license          = 'MIT'
  s.author           = { "Eddie Lau" => "eddie@touchutility.com" }
  s.source           = { :git => "https://github.com/eddy-lau/ELMultiTab.git", :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'
  s.requires_arc = false
  s.source_files = 'ELMultiTab/Classes/**/*'
  s.public_header_files = 'ELMultiTab/Classes/ELMultiTab.h', 'ELMultiTab/Classes/ELMultiTabViewController.h', 'ELMultiTab/Classes/ELTabOrientation.h'
  s.dependency 'MKNumberBadgeView', '~> 0.0'
  s.dependency 'RegexKitLite-NoWarning', '~> 1.1'
end
