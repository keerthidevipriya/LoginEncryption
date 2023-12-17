//
//  SwifyText.swift
//  LoginEncryption
//
//  Created by Keerthi Devipriya(kdp) on 13/12/23.
//

import Foundation
import UIKit

enum RSAError: Error {
    case base64Error
    case stringToDataConversionFailed
    case keyGenerationFailed(error: Error?)
}

class RSAEncryption {
    static let shared = RSAEncryption()
    
    func generateRSAKeyPair(keySize: Int = 2048, tag: String = Bundle.main.bundlePath) throws -> (privateKey: SecKey?, publicKey: SecKey?) {
        guard let tagData = tag.data(using: .utf8) else {
            throw RSAError.stringToDataConversionFailed
        }
        
        let isPermanent = true
        let attributes: [CFString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits: keySize,
            kSecPrivateKeyAttrs: [
                kSecAttrIsPermanent: isPermanent,
                kSecAttrApplicationTag: tagData,
                // kSecAttrKeyType: kSecAttrKeyTypeRSA // Add this line
            ],
            kSecPublicKeyAttrs: [
                kSecAttrIsPermanent: isPermanent,
                kSecAttrApplicationTag: tagData,
                // kSecAttrKeyType: kSecAttrKeyTypeRSA // Add this line
            ]
        ]
        
        var error: Unmanaged<CFError>?
        guard let privKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error),
              let pubKey = SecKeyCopyPublicKey(privKey) else {
            throw RSAError.keyGenerationFailed(error: error?.takeRetainedValue() ?? nil)
        }
        
        return (privateKey: privKey, publicKey: pubKey)
    }
}

extension RSAEncryption {
    // Encrypt using SecKey
    func encryptSec(data: Data, publicKey: SecKey) -> Data? {
        var error: Unmanaged<CFError>?
        if let encryptedData = SecKeyCreateEncryptedData(publicKey, .rsaEncryptionOAEPSHA1, data as CFData, &error) as Data? {
            debugPrint("Encrypted data:\n", encryptedData.base64EncodedString())
            return encryptedData as Data
        } else {
            if let error = error?.takeRetainedValue() {
                debugPrint("Encrypted data:", error)
            } else {
                debugPrint("Unknown error encrypting data")
            }
        }
        return nil
    }
    // Decrypt using SecKey
    func decryptSec(data: Data, privateKey: SecKey) -> Data? {
        var error: Unmanaged<CFError>?
        if let decryptedData = SecKeyCreateDecryptedData(privateKey, .rsaEncryptionOAEPSHA1, data as CFData, &error) as Data? {
            let decryptedString = String(data: decryptedData, encoding: .utf8)
            debugPrint("Decrypted data:", decryptedString ?? "Unable to decode as UTF-8")
            return decryptedData
        } else {
            if let error = error?.takeRetainedValue() {
                debugPrint("Error decrypting data:", error)
            } else {
                debugPrint("Unknown error decrypting data")
            }
        }
        return nil
    }
}

extension SecKey {
    
    func data() -> Data? {
        var error: Unmanaged<CFError>?
        guard let keyData = SecKeyCopyExternalRepresentation(self, &error) as Data? else {
            let error = error!.takeRetainedValue() as Error
            debugPrint(error)
            return nil
        }
        return keyData
    }
    
    func base64String() -> String {
        let derKey = self.addHeader()
        let base64 = base64Encode(derKey)
        return base64
    }
    
    private func base64Encode(_ key: Data) -> String {
        return key
            .base64EncodedString( options: [.endLineWithLineFeed, .endLineWithCarriageReturn, .lineLength76Characters])
            .replacingOccurrences(of: "\n", with: "")
    }
    
    private func addHeader() -> Data {
        var result = Data()
        guard let derKey = self.data() else {
            debugPrint("ERROR: Creating PEM Failed")
            return result
        }
        
        let encodingLength: Int = encodedOctets(derKey.count + 1).count
        let OID: [UInt8] = [0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
                            0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00]
        
        var builder: [UInt8] = []
        
        // ASN.1 SEQUENCE
        builder.append(0x30)
        
        // Overall size, made of OID + bitstring encoding + actual key
        let size = OID.count + 2 + encodingLength + derKey.count
        let encodedSize = encodedOctets(size)
        builder.append(contentsOf: encodedSize)
        result.append(builder, count: builder.count)
        result.append(OID, count: OID.count)
        builder.removeAll(keepingCapacity: false)
        
        builder.append(0x03)
        builder.append(contentsOf: encodedOctets(derKey.count + 1))
        builder.append(0x00)
        result.append(builder, count: builder.count)
        // Actual key bytes
        result.append(derKey)
        return result
    }
    
    private func encodedOctets(_ int: Int) -> [UInt8] {
        // Short form
        if int < 128 {
            return [UInt8(int)]
        }
        
        // Long form
        let i = (int / 256) + 1
        var len = int
        var result: [UInt8] = [UInt8(i + 0x80)]
        
        for _ in 0..<i {
            result.insert(UInt8(len & 0xFF), at: 1)
            len = len >> 8
        }
        
        return result
    }
}


extension UIApplication {
    
   public var mainKeyWindow: UIWindow? {
       if #available(iOS 13, *) {
         return UIApplication.shared.connectedScenes
             .filter { $0.activationState == .foregroundActive }
             .first(where: { $0 is UIWindowScene })
             .flatMap { $0 as? UIWindowScene }?.windows
             .first(where: \.isKeyWindow)
       } else {
           return UIApplication.shared.windows.first { $0.isKeyWindow }
       }
   }
}

func displayToastMessage(_ message : String) {
    let toastView = UILabel()
    toastView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    toastView.textColor = UIColor.white
    toastView.textAlignment = .center
    toastView.font = UIFont.preferredFont(forTextStyle: .caption1)
    toastView.layer.cornerRadius = 25
    toastView.layer.masksToBounds = true
    toastView.text = message
    toastView.numberOfLines = 0
    toastView.alpha = 0
    toastView.translatesAutoresizingMaskIntoConstraints = false
    
    guard let window = UIApplication.shared.mainKeyWindow else {
        return
    }
    window.addSubview(toastView)
    
    let horizontalCenterContraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .centerX, relatedBy: .equal, toItem: window, attribute: .centerX, multiplier: 1, constant: 0)
    
    let widthContraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 275)
    
    let verticalContraint: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=200)-[loginView(==50)]-68-|", options: [.alignAllCenterX, .alignAllCenterY], metrics: nil, views: ["loginView": toastView])
    
    NSLayoutConstraint.activate([horizontalCenterContraint, widthContraint])
    NSLayoutConstraint.activate(verticalContraint)
    
    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
        toastView.alpha = 1
    }, completion: nil)
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            toastView.alpha = 0
        }, completion: { finished in
            toastView.removeFromSuperview()
        })
    })
}
/*
 /*
  let notif = LocalNotificationMethod()
  notif.scheduleLocalNotification(
      titleOfNotification: "Hello",
      subtitleOfNotification: "Lets go to Login page",
      messageOfNotification: "Please tap here",
      soundOfNotification: String(),
      dateOfNotification: "2023-12-17 04:26"
  )
  */
 */


class LocalNotificationMethod : NSObject {
    
    static let notificationInstance = LocalNotificationMethod()
    
    let requestIdentifier = "SampleRequest" //identifier is to cancel the notification request
    
    internal func scheduleLocalNotification(titleOfNotification:String, subtitleOfNotification:String, messageOfNotification:String, soundOfNotification:String, dateOfNotification:String) {
        
        if #available(iOS 10.0, *) {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd hh:mm"
            let date3 = formatter.date(from: dateOfNotification)
            
            let content = UNMutableNotificationContent()
            content.body = NSString.localizedUserNotificationString(forKey: titleOfNotification, arguments: nil)
            content.sound = soundOfNotification.count > 0 ? UNNotificationSound.init(named: UNNotificationSoundName(rawValue: soundOfNotification + ".mp3") ) : UNNotificationSound.default
            
            let trigger = UNCalendarNotificationTrigger.init(dateMatching: NSCalendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date3!), repeats: false)
            
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request){(error) in
                
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    print("Successfully Done")
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
}
