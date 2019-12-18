Pod::Spec.new do |spec|
  spec.name                   = 'AP_PaySDK'
  spec.version                = '2.0'
  spec.summary                = 'Pod for PayDollar SDK.'
  spec.description            = 'PAYSDK from Asiapay. AsiaPay is a premier digital payment solution and technology vendor. We strive to bring advanced, secured, integrated, and cost-effective digital payment processing solutions and services to banks and e-businesses around the world. Our services are in abundance, covering international credit cards, debit cards, bank account/net banking, eWallets, over-the-counters, prepaid card and other digital means.'
  spec.homepage               = 'https://asiapay.com/index.html'
  spec.license                = { :type => 'MIT', :file => 'LICENSE' }
  spec.author                 = { 'Asiapay Limited' => 'vaibhav.meshram@asiapay.com' }
  spec.platform               = :ios, '11.0'
  spec.ios.deployment_target  = '11.0'
  spec.swift_versions         = ['4', '4.1', '4.2', '5', '5.1']
  spec.vendored_frameworks    = 'AP_PaySDK.framework'
  spec.source                 = { :git => 'https://github.com/vaibhav-asiapayindia/AP_PaySDK.git', :tag => spec.version }
  # spec.source                 = { :http => 'https://test.paydollar.com/b2cDemo/PaySDK.zip' }
end
