Pod::Spec.new do |s|
  s.name         = "iOSHelper"
  s.version      = "0.0.1"
  s.summary      = "some helpers"
  s.homepage     = "https://github.com/kampfgnu/iOSHelper"
  s.authors      = { "kampfgnu" => "heinilein@hotmail.com" }  
  s.source       = { :git => "https://github.com/kampfgnu/iOSHelper.git" }
  s.source_files = 'Classes', 'iOSHelper/Classes/*.{h,m}'
  s.requires_arc = false
  s.platform     = :ios, '5.0'
  s.ios.deployment_target = '5.0'
  s.prefix_header_contents = '
#include <iOSHelper.h>
  '
  s.frameworks = 'Accounts'
end
