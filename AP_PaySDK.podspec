# Pod::Spec.new do |spec|
# spec.name             			= 'AP_PaySDK'
# spec.version          			= '0.0.30'
# spec.license      	  			= { :type => "MIT", :file => "LICENSE" }
# spec.summary          			= 'Pod for PayDollar SDK'
# spec.homepage         			= 'https://www.asiapay.com'
# spec.authors          			= { 'Asiapay Limited' => 'vaibhav.meshram@asiapay.com' }
# spec.ios.deployment_target 		= '10.0'
# spec.ios.vendored_frameworks 	= 'AP_PaySDK.framework'
# spec.frameworks            		= 'SystemConfiguration', 'CoreTelephony', 'QuartzCore', 'CoreText', 'CoreGraphics', 'UIKit', 'Foundation','CFNetwork', 'CoreMotion'
# spec.libraries             		= 'z', 'c++'
# # spec.resource              		= 'AlipaySDK.bundle'
# # spec.vendored_frameworks   		= 'AlipaySDK.framework'
# # spec.source            			= { :type => "zip", :http => 'https://test.paydollar.com/b2cDemo/PaySDK.zip' }
# spec.source            			= { :type => "zip", :http => 'http://192.168.64.2/PaySDK/AP_PaySDK.zip'}
# # spec.source            			= { :type => "zip", :http => 'http://192.168.64.2/PaySDK/AP_PaySDKUniversal.zip'}
# spec.exclude_files 				= "Classes/Exclude"
# spec.requires_arc          		= true
# end

Pod::Spec.new do |spec|
spec.name             			= 'AP_PaySDK'
spec.version          			= '0.0.32'
spec.license      	  			= { :type => "MIT", :file => "LICENSE" }
spec.summary          			= 'Pod for PayDollar SDK'
spec.homepage         			= 'https://www.asiapay.com'
spec.authors          			= { 'Asiapay Limited' => 'vaibhav.meshram@asiapay.com' }
spec.ios.deployment_target 		= '10.0'
spec.vendored_frameworks 		= 'AP_PaySDK.framework'
# spec.source            			= { :type => "zip", :http => 'https://test.paydollar.com/b2cDemo/PaySDK1.zip' }
spec.source            			= { :type => "zip", :http => 'https://raw.githubusercontent.com/vaibhav-asiapayindia/AP_PaySDK/master/AP_PaySDK.framework.zip'}
spec.exclude_files 				= "Classes/Exclude"
spec.requires_arc          		= true
spec.swift_versions 			= ['4.0', '4.2', '5.0', '5.1']
spec.platform 					= :ios
end

