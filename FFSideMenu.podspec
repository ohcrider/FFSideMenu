#
# Be sure to run `pod lib lint FFSideMenu.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = "FFSideMenu"
s.version          = "0.1.0"
s.summary          = "The simple way to custom side menu with navigation bar."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
s.description      = <<-DESC
FFSideMenu can support you custom your cool side menu with navigation bar.
DESC

s.homepage         = "https://github.com/fewspider/FFSideMenu"
s.screenshots     = "https://c2.staticflickr.com/6/5645/21668838170_f028dfac61_o.gif"
s.license          = 'MIT'
s.author           = { "fewspider" => "fewspider@gmail.com" }
s.source           = { :git => "https://github.com/fewspider/FFSideMenu.git", :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/fewspider'

s.platform     = :ios, '9.0'
s.requires_arc = true

s.source_files = 'Pod/Lib/*'
s.resource_bundles = {
'FFSideMenu' => ['Pod/Assets/*.png']
}

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end
