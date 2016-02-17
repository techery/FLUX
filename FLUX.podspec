#
# Be sure to run `pod lib lint FLUX.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "FLUX"
  s.version          = "0.1.1"
  s.summary          = "Objective-C implementation of FLUX architecture pattern"
  s.description      = <<-DESC
                       DESC

  s.homepage         = "https://github.com/techery/FLUX"
  s.license          = 'MIT'
  s.author           = { "Alexey Fayzullov" => "alex.f@techery.io" }
  s.source           = { :git => "https://github.com/techery/FLUX.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'FLUX' => ['Pod/Assets/*.png']
  }

  s.prefix_header_contents = '#import <libextobjc/extobjc.h>'

  s.dependency 'libextobjc'
  s.dependency 'KVOController'
end
