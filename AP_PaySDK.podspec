Pod::Spec.new do |spec|
spec.name						= 'AP_PaySDK'
spec.version					= '0.0.47'
spec.description				= 'PAYSDK from Asiapay. AsiaPay is a premier digital payment solution and technology vendor. We strive to bring advanced, secured, integrated, and cost-effective digital payment processing solutions and services to banks and e-businesses around the world. Our services are in abundance, covering international credit cards, debit cards, bank account/net banking, eWallets, over-the-counters, prepaid card and other digital means.'
spec.license					= { :type => "MIT", :file => "LICENSE" }
spec.summary					= 'Pod for PayDollar SDK'
spec.homepage					= 'https://www.asiapay.com'
spec.authors					= { 'Asiapay Limited' => 'vaibhav.meshram@asiapay.com' }
spec.ios.deployment_target		= '11.0'
spec.swift_versions				= ['4', '4.1', '4.2', '5', '5.1']
spec.vendored_frameworks		= 'AP_PaySDK.framework'
spec.source						= { :type => "zip", :http => 'https://raw.githubusercontent.com/vaibhav-asiapayindia/AP_PaySDK/master/PaySDK.zip'}
spec.requires_arc				= true
spec.platform					= :ios, "11.0"
end
