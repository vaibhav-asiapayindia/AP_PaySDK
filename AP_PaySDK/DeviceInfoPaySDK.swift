//
//  DeviceInfo.swift
//  PayDollarSDK
//
//  Created by AsiaPay Limited on 06/12/18.
//  Copyright © 2018 AsiaPay Limited. All rights reserved.
//


import Foundation
import UIKit
import CoreLocation
import AdSupport



class DeviceInfoPaySDK : NSObject, CLLocationManagerDelegate {
    
    static let sharedDeviceInfo = DeviceInfoPaySDK()//DeviceInfo()
    let deviceModel = UIDevice.current.model as String
    let osName = UIDevice.current.systemName as String
    let osVersion = UIDevice.current.systemVersion as String
    let timeZone = NSTimeZone.local.identifier
    lazy var screenResolution = ""
    lazy var deviceUUID = ""
    var long = ""
    var lat = ""
    var locationManager : CLLocationManager!
    
    override init() {
        super.init()
        screenResolution = getScreenResolution()
        deviceUUID = (UIDevice.current.identifierForVendor?.uuidString.replacingOccurrences(of: "-", with: ""))!
    }
    
    func getScreenResolution() -> String {
        var screenWidth: CGFloat {
            if UIDevice.current.orientation == UIDeviceOrientation.portrait {
                return UIScreen.main.bounds.size.width
            } else {
                return UIScreen.main.bounds.size.height
            }
        }
        var screenHeight: CGFloat {
            if UIDevice.current.orientation == UIDeviceOrientation.portrait{
                return UIScreen.main.bounds.size.height
            } else {
                return UIScreen.main.bounds.size.width
            }
        }
        return "\(screenWidth.description) x \(screenHeight.description)"
    }
    //
    //
    //func getDeviceOrientation() -> String {
    //if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
    //return "LandscapeLeft"
    //} else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
    //return "LandscapeRight"
    //} else if UIDevice.current.orientation == UIDeviceOrientation.portrait {
    //return "Portrait"
    //} else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown {
    //return "PortraitUpsideDown"
    //} else if UIDevice.current.orientation == UIDeviceOrientation.faceDown {
    //return "FaceDown"
    //} else if UIDevice.current.orientation == UIDeviceOrientation.faceUp {
    //return "FaceUp"
    //} else if UIDevice.current.orientation == UIDeviceOrientation.unknown {
    //return "Unknown"
    //} else {
    //return "No"
    //}
    //}
    //
    //
    //func getUserInterfaceIdiom() -> String {
    //if UIDevice.current.userInterfaceIdiom == .pad {
    //return "iPad Style UI"
    //} else if UIDevice.current.userInterfaceIdiom == .phone {
    //return "iPhone Style UI"
    //} else if UIDevice.current.userInterfaceIdiom == .carPlay {
    //return "Car Play Style UI"
    //} else if UIDevice.current.userInterfaceIdiom == .tv {
    //return "TV Style UI"
    //} else if UIDevice.current.userInterfaceIdiom == .unspecified {
    //return "Unspecified UI"
    //}
    //return ""
    //}
    //
    //
    func getLocation() {
        self.locationManager =  CLLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            long = String(format:"%f", self.locationManager.location?.coordinate.longitude ?? "0")
            lat = String(format:"%f",self.locationManager.location?.coordinate.latitude ?? "0")
        } else {
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        if let location = locations.first {
            long = String(location.coordinate.longitude)
            lat = String(location.coordinate.latitude)
        }
    }
    //
    //
    //func isDeviceJailbroken() -> Bool {
    //#if arch(i386) || arch(x86_64)
    //return false
    //#else
    //let fileManager = FileManager.default
    //if (fileManager.fileExists(atPath: "/bin/bash") ||
    //fileManager.fileExists(atPath: "/usr/sbin/sshd") ||
    //fileManager.fileExists(atPath: "/etc/apt")) ||
    //fileManager.fileExists(atPath: "/private/var/lib/apt/") ||
    //fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
    //fileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") {
    //return true
    //} else {
    //return false
    //}
    //#endif
    //}
    //
    //
    //func getIFAddresses() -> [String] {
    //var addresses = [String]()
    //// Get list of all interfaces on the local machine:
    //var ifaddr : UnsafeMutablePointer<ifaddrs>?
    //guard getifaddrs(&ifaddr) == 0 else { return [] }
    //guard let firstAddr = ifaddr else { return [] }
    //// For each interface ...
    //for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
    //let flags = Int32(ptr.pointee.ifa_flags)
    //let addr = ptr.pointee.ifa_addr.pointee
    //// Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
    //if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
    //if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
    //// Convert interface address to a human readable string:
    //var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
    //if (getnameinfo(ptr.pointee.ifa_addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
    //nil, socklen_t(0), NI_NUMERICHOST) == 0) {
    //let address = String(cString: hostname)
    //addresses.append(address)
    //}
    //}
    //}
    //}
    //freeifaddrs(ifaddr)
    //return addresses
    //}
}


//Extension to get the device model name
//extension UIDevice {
//
//var modelName: String {
//var systemInfo = utsname()
//uname(&systemInfo)
//let machineMirror = Mirror(reflecting: systemInfo.machine)
//let identifier = machineMirror.children.reduce("") { identifier, element in
//guard let value = element.value as? Int8, value != 0 else { return identifier }
//return identifier + String(UnicodeScalar(UInt8(value)))
//}
//switch identifier {
//case "iPod5,1":                                 return "iPod Touch 5"
//case "iPod7,1":                                 return "iPod Touch 6"
//case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
//case "iPhone4,1":                               return "iPhone 4s"
//case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
//case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
//case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
//case "iPhone7,2":                               return "iPhone 6"
//case "iPhone7,1":                               return "iPhone 6 Plus"
//case "iPhone8,1":                               return "iPhone 6s"
//case "iPhone8,2":                               return "iPhone 6s Plus"
//case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
//case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
//case "iPhone8,4":                               return "iPhone SE"
//case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
//case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
//case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
//case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
//case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
//case "iPad6,11", "iPad6,12":                    return "iPad 5"
//case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
//case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
//case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
//case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
//case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
//case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
//case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
//case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
//case "iPod1,1"    : return "iPod1"
//case "iPod2,1"    : return "iPod2"
//case "iPod3,1"    : return "iPod3"
//case "iPod4,1"    : return "iPod4"
//case "iPhone10,1" : return "iPhone8"
//case "iPhone10,2" : return "iPhone8plus"
//case "iPhone10,3" : return "iPhoneX"
//case "iPhone10,6" : return "iPhoneX"
//case "iPhone11,2" : return "iPhoneXS"
//case "iPhone11,4" : return "iPhoneXSmax"
//case "iPhone11,6" : return "iPhoneXSmax"
//case "iPhone11,8" : return "iPhoneXR"
//case "AppleTV5,3":                              return "Apple TV"
//case "i386", "x86_64":                          return "Simulator"
//case "unrecognized"        :                    return "?unrecognized?"
//default:                                        return identifier
//}
//}
//
//}

extension DeviceInfoPaySDK {
    
    func getDeviceInfo() -> String {
        let mainDic : [String:Any] = ["device": ["id":deviceUUID, "model": deviceModel, "os":osName, "ver":osVersion, "lang":NSLocale.preferredLanguages[0], "tz":timeZone, "loc":lat + long, "res":screenResolution, "app":Bundle.main.bundleIdentifier!, "sdk":AP_PaySDKVersionNumber]]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: mainDic, options: [])
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
            return jsonString!
        } catch {
        }
        return ""
    }
}
