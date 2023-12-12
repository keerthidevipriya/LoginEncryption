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
    func makeEncryptData(_ pswd: String, completion: (String) -> Void) {
        Utility.encryptData(pswd, completion: completion)
    }
    
    func getDecryptData(_ encryptedPasswordText: String) -> String {
        return Utility.decryptData(encryptedPasswordText)
    }
}
