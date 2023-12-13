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
        completion(pswd)
        //Utility.encryptData(pswd, completion: completion)
    }
    
    func getDecryptData(_ encryptedPasswordText: String) -> String {
        guard let publicKey = try? rsa.generateRSAKeyPair(keySize: 2048).publicKey,
                  let privateKey = try? rsa.generateRSAKeyPair().privateKey
        else {
            return String()
        }
        guard let encrypted = rsa.encryptSec(data: encryptedPasswordText.data(using: .utf8)!, publicKey: publicKey) else {
            return String()
        }
        print("Pub: \n", publicKey.base64String())
        print("Priv: \n ", privateKey.base64String())
        A.a(plainText: encryptedPasswordText, publicKey: publicKey, privateKey: privateKey)
        guard let decrypted = rsa.decryptSec(data: encrypted, privateKey: privateKey) else { return "dummy" }
        return String(data: decrypted, encoding: .utf8) ?? String()
        // return Utility.decryptData(encryptedPasswordText)
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
    }
}
