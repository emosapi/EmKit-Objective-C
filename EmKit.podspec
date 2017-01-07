Pod::Spec.new do |s|
  s.name         = "EmKit"
  s.version      = "0.0.1"
  s.summary      = "Emos Api Kit"
  s.homepage     = "https://github.com/emosapi/EmKit"
  s.license      = "MIT"
  s.author       = { "terry" => "terry@emos.hk" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/emosapi/EmKit.git", :tag => s.version.to_s }
  s.source_files = "EmKit/*"
  s.platform	 = :ios,'8.0'
  s.requires_arc = true
  s.dependency 'AFNetworking', '~> 3.1.0'
  s.dependency 'MPMessagePack', '~> 1.3.12'
  s.dependency 'PINCache', '~> 3.0.1-beta'
end
