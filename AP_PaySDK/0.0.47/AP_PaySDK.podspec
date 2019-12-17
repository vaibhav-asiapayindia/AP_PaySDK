
#
# Be sure to run `pod lib lint AP_PaySDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name					= 'AP_PaySDK'
  s.version					= '0.0.47'
  s.summary					= 'Pod for PayDollar SDK.'
  s.description				= 'Pod for PayDollar SDK from Asiapay. AP_PaySDK PayDollar is a payment gateway developed by AsiaPay for the ecommerce space in India, enabling online merchants to easily facilitate payment acceptance through card-based payments. The payment platform also offers a vast range of value-added services – from recurring payments and tokenization to a fully-integrated booking engine, allowing Indian businesses to go beyond payment processing.'
  s.homepage				= 'https://www.asiapay.com'
  s.license					= { :type => 'MIT', :file => 'LICENSE' }
  s.authors					= { 'Asiapay Limited' => 'vaibhav.meshram@asiapay.com' }
  s.source					= { :type => "zip", :http => 'https://raw.githubusercontent.com/vaibhav-asiapayindia/AP_PaySDK/master/PaySDK.zip'}
  s.ios.deployment_target 	= '11.0'
  s.swift_versions			= ['4', '4.1', '4.2', '5', '5.1']
  s.vendored_frameworks		= 'AP_PaySDK.framework'
  s.platform				= :ios, "11.0"
end
