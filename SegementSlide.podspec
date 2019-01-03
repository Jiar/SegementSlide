Pod::Spec.new do |s|

  s.name = 'SegementSlide'
  s.version = '0.6'
  s.summary = 'SegementSlide'

  s.homepage = 'https://github.com/Jiar/SegementSlide'
  s.license = { :type => "Apache-2.0", :file => "LICENSE" }

  s.author = { "Jiar" => "iiimjiar@gmail.com" }

  s.platform = :ios
  s.ios.deployment_target = '9.0'

  s.source = { :git => "https://github.com/Jiar/SegementSlide.git", :tag => "#{s.version}" }
  s.ios.framework  = 'UIKit'
  s.ios.source_files = 'Source/*.swift', 'Source/**/*.swift', 'Source/**/**/*.swift'

  s.module_name = 'SegementSlide'
  s.requires_arc = true

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }
  s.static_framework = true

  s.dependency 'SnapKit', '~> 4.2.0'
  
end
