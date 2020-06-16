#
# Be sure to run `pod lib lint SwiftyBase.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftyBase'
  s.version          = '1.2.34'
  s.summary          = 'Base Project For iOS in Swift 5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Base Project Create for iOS. Into Base Project BaseController, BaseView, BaseNavigation ,BaseControls Added.
                       DESC

  s.homepage         = 'https://github.com/mspvirajpatel/SwiftyBase'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Viraj Patel' => 'mspviraj@hotmail.com' }
  s.source           = { :git => 'https://github.com/mspvirajpatel/SwiftyBase.git', :tag => s.version }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'SwiftyBase/Classes/**/*'
  s.swift_versions = ['5.0']
  
  # s.resource_bundles = {
  #   'SwiftyBase' => ['SwiftyBase/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
