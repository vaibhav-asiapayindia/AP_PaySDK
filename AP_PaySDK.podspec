Pod::Spec.new do |spec|
spec.name             			= 'AP_PaySDK'
spec.version          			= '0.0.31'
spec.license      	  			= { :type => "MIT", :file => "LICENSE" }
spec.summary          			= 'Pod for PayDollar SDK'
spec.homepage         			= 'https://www.asiapay.com'
spec.authors          			= { 'Asiapay Limited' => 'vaibhav.meshram@asiapay.com' }
spec.ios.deployment_target 		= '10.0'
spec.ios.vendored_frameworks 	= 'AP_PaySDK.framework'
spec.source            			= { :type => "zip", :http => 'https://test.paydollar.com/b2cDemo/PaySDK1.zip' }
spec.exclude_files 				= "Classes/Exclude"
spec.requires_arc          		= true
end

