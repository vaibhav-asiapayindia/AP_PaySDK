Pod::Spec.new do |spec|
spec.name             			= 'AP_PaySDK'
spec.version          			= '0.0.37'
spec.license      	  			= { :type => "MIT", :file => "LICENSE" }
spec.summary          			= 'Pod for PayDollar SDK'
spec.homepage         			= 'https://www.asiapay.com'
spec.authors          			= { 'Asiapay Limited' => 'vaibhav.meshram@asiapay.com' }
spec.ios.deployment_target 		= '10.0'
spec.vendored_frameworks 		= 'AP_PaySDK.framework'
spec.source            			= { :type => "zip", :http => 'https://raw.githubusercontent.com/vaibhav-asiapayindia/AP_PaySDK/master/PaySDK.zip'}
spec.exclude_files 				= "Classes/Exclude"
spec.requires_arc          		= true
spec.swift_versions 			= ['4.0', '4.2', '5.0', '5.1']
spec.platform 					= :ios, "10.0"
end

