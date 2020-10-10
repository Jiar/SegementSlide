platform :ios, "10.0"
use_frameworks!
inhibit_all_warnings!

project './Example.xcodeproj'

def common_pods
    pod 'SegementSlide', :path => './'
end

target 'Example' do
	pod 'JXSegmentedView'
    pod 'MJRefresh'
    pod 'SnapKit'
    pod 'MBProgressHUD'
    common_pods
end

target 'ExampleTests' do
    common_pods
end