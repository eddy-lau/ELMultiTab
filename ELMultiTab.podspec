#
# Be sure to run `pod lib lint ELMultiTab.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ELMultiTab"
  s.version          = "0.1.1"
  s.summary          = "A multi-tab user interface"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A multi-tab user interface like a desktop web browser
                       DESC

  s.homepage         = "https://github.com/eddy-lau/ELMultiTab"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Eddie Lau" => "eddie@touchutility.com" }
  s.source           = { :git => "https://github.com/eddy-lau/ELMultiTab.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'
  s.requires_arc = false

  s.source_files = 'ELMultiTab/Classes/**/*'
  s.resource_bundles = {
    'ELMultiTab' => ['ELMultiTab/Assets/*.png']
  }

  s.public_header_files = 'ELMultiTab/Classes/ELMultiTab.h', 'ELMultiTab/Classes/ELMultiTabViewController.h', 'ELMultiTab/Classes/ELTabOrientation.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'MKNumberBadgeView', '~> 0.0'
  s.dependency 'RegexKitLite-NoWarning', '~> 1.1'

end
