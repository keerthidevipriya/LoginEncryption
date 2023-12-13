//
//  LoginComposer.swift
//  LoginEncryption
//
//  Created by Keerthi Devipriya(kdp) on 12/12/23.
//

import UIKit
import Foundation
import LoginModule

final class LoginComposer {
    static func getInitialViewController() -> UIViewController {
        let vc = LoginVC.makeViewController(validations: LoginValidations())
        return vc
    }
}

class LoginValidations: LoginModule.LoginValidation {
    let rsa = RSAEncryption.shared
    
    func makeEncryptData(_ pswd: String, completion: (String) -> Void) {
        var ans = String()
        let tag = Bundle.main.bundlePath.data(using: .utf8)!
        let attributes: [String: Any] =
        [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: 2048,
            kSecPrivateKeyAttrs as String:
                [
                    kSecAttrIsPermanent as String: true,
                    kSecAttrApplicationTag as String: tag
                ]
        ]
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            completion(ans)
            return
        }
        guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
            completion(ans)
            return
        }
        let algorithm: SecKeyAlgorithm = .rsaEncryptionOAEPSHA512
        
        guard SecKeyIsAlgorithmSupported(publicKey, .encrypt, algorithm) else {
            completion(ans)
            return
        }
        guard (pswd.count < (SecKeyGetBlockSize(publicKey)-130)) else {
            return
        }
        
        let plainText = pswd.data(using: .utf8)!
        guard let cipherText = SecKeyCreateEncryptedData(publicKey,
                                                         algorithm,
                                                         plainText as CFData,
                                                         &error) as Data? else {
            return
        }
        guard SecKeyIsAlgorithmSupported(privateKey, .decrypt, algorithm) else {
            return
        }
        
        guard cipherText.count == SecKeyGetBlockSize(privateKey) else {
            return
        }
        
        completion(pswd)
        //Utility.encryptData(pswd, completion: completion)
    }
    
    func getDecryptData(_ encryptedPasswordText: String) -> String {
        let algorithm: SecKeyAlgorithm = .rsaEncryptionOAEPSHA512

        let tag = Bundle.main.bundlePath.data(using: .utf8)!
        let attributes: [String: Any] =
        [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: 2048,
            kSecPrivateKeyAttrs as String:
                [
                    kSecAttrIsPermanent as String: true,
                    kSecAttrApplicationTag as String: tag
                ]
        ]
        
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            return String()
            // throw RSAError.keyGenerationFailed(error: error?.takeRetainedValue() ?? nil) //error!.takeRetainedValue() as Error
        }
        guard let publicKey = SecKeyCopyPublicKey(privateKey) else { return String() }
        
        guard SecKeyIsAlgorithmSupported(publicKey, .encrypt, algorithm) else {
            return String()
            // throw &error
        }
        
        guard (encryptedPasswordText.count < (SecKeyGetBlockSize(publicKey)-130)) else {
            return String()
            // throw &error
        }
        
        let plainText = encryptedPasswordText.data(using: .utf8)!
        guard let cipherText = SecKeyCreateEncryptedData(publicKey,
                                                         algorithm,
                                                         plainText as CFData,
                                                         &error) as Data? else {
            return String()
                           //                                 throw error!.takeRetainedValue() as Error
        }
        guard SecKeyIsAlgorithmSupported(privateKey, .decrypt, algorithm) else {
            return String()
            // throw &error
        }
        
        guard cipherText.count == SecKeyGetBlockSize(privateKey) else {
            return String()
            // throw &error
        }
        
        guard let clearText = SecKeyCreateDecryptedData(privateKey,
                                                        algorithm,
                                                        cipherText as CFData,
                                                        &error) as Data? else {
            return String()
                                                           // throw error!.takeRetainedValue() as Error
        }
        
        guard let decryptedString = String(data: clearText, encoding: .utf8) else { return String() }
        print("Private key can encrypt/decrypt: ", SecKeyIsAlgorithmSupported(privateKey, .decrypt, algorithm))
        print("pub key----\(publicKey)")
        print("private key---\(privateKey)")
        print("clearText---\(decryptedString)")
        return decryptedString
    }
}


class A  {
    class func a(plainText: String, publicKey: SecKey, privateKey: SecKey) {
        // Encrypt
        let algo: SecKeyAlgorithm = .rsaEncryptionOAEPSHA512AESGCM
        print("Public key can encrypt/decrypt: ", SecKeyIsAlgorithmSupported(publicKey, .encrypt, algo), SecKeyIsAlgorithmSupported(publicKey, .decrypt, algo))

        var error: Unmanaged<CFError>? = nil
        let cipherText = SecKeyCreateEncryptedData(publicKey, algo, plainText.data(using: .utf8)! as CFData, &error)
        if (cipherText == nil) {
            print(error)
        }
        print("Private key can encrypt/decrypt: ", SecKeyIsAlgorithmSupported(privateKey, .encrypt, algo), SecKeyIsAlgorithmSupported(privateKey, .decrypt, algo))

        let recovered = SecKeyCreateDecryptedData(privateKey, algo, cipherText!, &error)
        if (recovered == nil) {
            print(error)
        }
        print("decrypted text---\(recovered)")
    }
}
