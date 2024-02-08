#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint bilmobileadsflutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'bilmobileadsflutter'
  s.version          = '1.5.0'
  s.summary          = 'A flutter plugin for integrate ValueImpressionSDK.'
  s.description      = 'A flutter plugin for integrate ValueImpressionSDK. ValueImpression is the trusted platform for premium publishers. Our patented proprietary advertising optimization technology has helped hundreds of publishers increase their revenue from 40 to 300%.'
  s.homepage         = 'https://valueimpression.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'valueimpression' => 'linhhn@bil.vn' }

  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'

  s.platform         = :ios, '11.0'
  s.swift_version    = '5.0'

  s.ios.deployment_target = '11.0'
  # s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS' => 'armv7 arm64 x86_64' }
  s.static_framework = true

  s.dependency 'Flutter'
  s.dependency "BilMobileAds", '2.2.2'
  s.dependency "PrebidMobile", '2.1.2'
  s.dependency "Google-Mobile-Ads-SDK", '10.9.0'
end
