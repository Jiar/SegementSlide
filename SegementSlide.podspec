Pod::Spec.new do |s|

  s.name = 'SegementSlide'
  s.version = '3.0.0'
  s.summary = 'Multi-tier UIScrollView nested scrolling solution. 😋😋😋'

  s.homepage = 'https://github.com/Jiar/SegementSlide'
  s.license = { :type => 'Apache-2.0', :file => 'LICENSE' }

  s.author = { 'Jiar' => 'iiimjiar@gmail.com' }
  s.social_media_url = 'https://github.com/Jiar'

  s.platform = :ios
  s.ios.deployment_target = '9.0'

  s.source = { :git => 'https://github.com/Jiar/SegementSlide.git', :tag => "#{s.version}" }
  s.ios.framework  = 'UIKit'
  s.ios.source_files = 'Source/*.swift', 'Source/**/*.swift'

  s.module_name = 'SegementSlide'
  s.requires_arc = true
  s.swift_version = '5.1'

  s.static_framework = true
  
end
