Pod::Spec.new do |s|
  s.name         = "iOSHelper"
  s.version      = "0.0.1"
  s.summary      = "some helpers"
  s.homepage     = "https://github.com/kampfgnu/iOSHelper"
  s.authors      = { "kampfgnu" => "heinilein@hotmail.com" }  
  s.source       = { :git => "https://github.com/kampfgnu/iOSHelper.git" }
  s.source_files = 'iOSHelper/Classes/*.{h,m}', 'iOSHelper/Classes/Core/*.{h,m}', 'iOSHelper/Classes/Misc/*.{h,m}', 'iOSHelper/Classes/UIKit/*.{h,m}'
  s.frameworks = 'QuartzCore', 'CoreGraphics'
  s.requires_arc = true
  s.platform     = :ios, '5.0'
  s.ios.deployment_target = '5.0'

  s.subspec "iOSHelper" do |ss|
    ss.source_files = "iOSHelper"
    ss.public_header_files = "iOSHelper/*.h"
    ss.prefix_header_contents = '
#include <iOSHelper.h>
    '
  end
end
