#
# Be sure to run `pod lib lint HSModules.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HSModules'
  s.version          = '0.1.4'
  s.summary          = '项目组件'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/TAEYANGXU/HSModules/'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'TAEYANGXU' => 'albert_xyz@163.com' }
  s.source           = { :git => 'https://github.com/TAEYANGXU/HSModules.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

#  s.source_files = 'HSModules/Classes/**/*'
  s.subspec 'VideoModule' do |videoModule|
        videoModule.source_files = 'HSModules/Classes/VideoModule/**/*'
        videoModule.public_header_files = 'HSModules/Classes/VideoModule/**/*.h'
  end
  s.subspec 'HUD' do |hud|
        hud.source_files = 'HSModules/Classes/HUD/**/*'
        hud.public_header_files = 'HSModules/Classes/HUD/**/*.h'
  end
  # s.resource_bundles = {
  #   'HSModules' => ['HSModules/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
    s.frameworks = 'UIKit'
    s.dependency 'XyWidget'
    s.dependency 'Masonry'
    s.dependency 'VHallSDK_Live'
    s.dependency 'SVProgressHUD'
    s.dependency 'MBProgressHUD'
  
end
