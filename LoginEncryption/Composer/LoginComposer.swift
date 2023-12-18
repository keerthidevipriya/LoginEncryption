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
    
    func makeEncryptData(_ pswd: String, completion: (String, Data) -> Void) {
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
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else { return }
        guard let publicKey = SecKeyCopyPublicKey(privateKey) else { return }
        displayToastMessage("Keypair generated")
        let algorithm: SecKeyAlgorithm = .rsaEncryptionOAEPSHA512
        
        guard SecKeyIsAlgorithmSupported(publicKey, .encrypt, algorithm) else { return }
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
        guard SecKeyIsAlgorithmSupported(privateKey, .decrypt, algorithm) else { return }
        
        guard cipherText.count == SecKeyGetBlockSize(privateKey) else { return }
        
        completion(pswd, cipherText)
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            displayToastMessage("Password is secured by two layer safety by encryption")
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            displayToastMessage("Password is decrypteddd")
        }
        return decryptedString
    }
}
