Pod::Spec.new do |s|
  s.name         = "LTxFile"
  s.version      = "0.0.1"
  s.summary      = "基础配置. "
  s.license      = "MIT"
  s.author             = { "liangtong" => "liangtongdev@163.com" }

  s.homepage     = "https://github.com/liangtongdev/LTxFile"
  s.platform     = :ios, "9.0"
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/liangtongdev/LTxFile.git", :tag => "#{s.version}", :submodules => true }
  
  
  s.frameworks = "Foundation"

  s.default_subspecs = 'Core'

  
  # Core
  s.subspec 'Core' do |sp|
    sp.source_files  =  "LTxFile/*.{h,m}"
    sp.public_header_files = "LTxFile/*.h"
  end

end
