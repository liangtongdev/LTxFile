Pod::Spec.new do |s|
  s.name         = "LTxFile"
  s.version      = "0.0.1"
  s.summary      = "文件操作. "
  s.license      = "MIT"
  s.author             = { "liangtong" => "liangtongdev@163.com" }

  s.homepage     = "https://github.com/liangtongdev/LTxFile"
  s.platform     = :ios, "9.0"
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/liangtongdev/LTxFile.git", :tag => "#{s.version}", :submodules => true }
  
  
  s.frameworks = "Foundation", "UIKit"

  s.default_subspecs = 'Core'

  s.subspec 'Utils' do |utils|
    utils.source_files  =  "LTxFile/Utils/*.{h,m}"
    utils.public_header_files = "LTxFile/Utils/*.h"
  end

  s.subspec 'Preview' do |priview|
    priview.source_files  =  "LTxFile/Preview/*.{h,m}"
    priview.public_header_files = "LTxFile/Preview/*.h"
    priview.dependency 'LTxFile/Utils'
  end 
  
  # Core
  s.subspec 'Core' do |core|
    core.public_header_files = "LTxFile/LTxFile.h"
    core.source_files  =  "LTxFile/LTxFile.h"
    core.dependency 'LTxFile/Preview'
  end

end
