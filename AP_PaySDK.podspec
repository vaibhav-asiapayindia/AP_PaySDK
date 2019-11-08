 # pod spec lint AP_PaySDK.podspec --allow-warings
 # pod trunk push AP_PaySDK.podspec
Pod::Spec.new do |spec|
spec.name             			= 'AP_PaySDK-swift4'
spec.version          			= '0.0.1'
spec.license      	  			= { :type => "MIT", :file => "LICENSE" }
spec.summary          			= 'PayDollar iOS SDK'
spec.homepage         			= 'https://www.asiapay.com'
spec.author          			= { 'asiapay-lib' => 'github@asiapay.com' }
spec.ios.deployment_target 		= '10.0'
spec.ios.vendored_frameworks 	= 'AP_PaySDK.framework'
spec.swift_version 				= '4.0'
spc.pod_target_xcconfig 		= { 'SWIFT_VERSION' => '4.0' }
spc.platform     				= :ios, "10.0"
spec.source            			= { :git => "https://github.com/vaibhav1don/sampleSDK.git", :tag => "1.0.0" }
# { :type => "zip", :http => 'https://mikesheen22.000webhostapp.com/pays/PaySDK-swift4.zip' }
spec.exclude_files 				= "Classes/Exclude"

end