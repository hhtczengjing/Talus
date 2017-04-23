Pod::Spec.new do |s|
  s.name                  = "Talus"
  s.version               = "0.1.0"
  s.summary               = "Talus: iOS 3rd-Share Component."
  s.homepage              = "https://github.com/hhtczengjing/Talus"
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { "zengjing" => "hhtczengjing@gmail.com" }
  s.source                = { :git => "https://github.com/hhtczengjing/Talus.git", :tag => "#{s.version}" }
  s.platform              = :ios, "7.0"
  s.requires_arc          = true
  s.framework             = 'UIKit'
  s.requires_arc          = true
  s.source_files          = 'Pod/Classes/**/*'
  s.public_header_files   = 'Pod/Classes/**/*.h'
  s.dependency 'Foundation-pd', '~> 0.1.5'
  s.dependency 'WeChatSDK-pd', '~> 1.7.1'
  s.dependency 'WeiboSDK-pd', '~> 3.1.4'
  s.dependency 'RenrenSDK-pd', '~> 0.1.2'
  s.dependency 'TencentOpenApiSDK-pd', '~> 3.1.2'
end