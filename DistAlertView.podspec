Pod::Spec.new do |s|

  s.name         = "DistAlertView"
  s.version      = "1.0.1"
  s.summary      = "DistAlertView is a clean and lightweight alert for your iOS app"
  s.author       = { "Damrin" => "75081647@qq.com" }
  s.homepage    = 'https://github.com/Damsir/DistAlertView'
  s.source      = { :git => 'https://github.com/Damsir/DistAlertView.git', :tag => s.version }
  s.license = "MIT"
  s.platform = :ios, "8.2"
  s.requires_arc = true
  s.source_files = "DistAlertView", "DistAlertView/**/*.{h,m}"
  # s.public_header_files = "DistSlideSegment/*.h"
  s.framework = 'UIKit'
  s.ios.deployment_target = "8.2"

end
