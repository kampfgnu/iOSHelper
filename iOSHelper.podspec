Pod::Spec.new do |s|
  s.name         = "iOSHelper"
  s.version      = "0.0.2"
  s.license      = { :type => 'zlib', :file => 'LICENCE.md' }
  s.summary      = "iOS helper classes for UIKit, FoundationKit and many other stuff that make life easier in almost every app."
  s.homepage     = "https://github.com/kampfgnu/iOSHelper"
  s.authors      = { "kampfgnu" => "heinilein@hotmail.com" }  
  s.source       = { :git => "https://github.com/kampfgnu/iOSHelper.git", :tag => '0.0.2' }
  s.source_files = 'iOSHelper/Classes/*.{h,m}', 'iOSHelper/Classes/Core/*.{h,m}', 'iOSHelper/Classes/Misc/*.{h,m}', 'iOSHelper/Classes/UIKit/*.{h,m}', 'iOSHelper/Classes/CoreGraphics/*.{h,m}', 'iOSHelper/Classes/Audio/*.{h,m}', 'iOSHelper/Classes/Subclasses/*.{h,m}'
  s.frameworks = 'QuartzCore', 'CoreGraphics', 'Accelerate'
  s.requires_arc = true
  s.platform     = :ios, '5.0'
  s.ios.deployment_target = '5.0'

end
