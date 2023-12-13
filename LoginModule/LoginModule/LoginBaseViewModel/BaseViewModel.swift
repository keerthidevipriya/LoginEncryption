//
//  BaseViewModel.swift
//  LoginModule
//
//  Created by Keerthi Devipriya(kdp) on 12/12/23.
//

import Foundation

public protocol LoginValidation {
    func makeEncryptData(_ pswd: String, completion: (String, Data) -> Void)
    func getDecryptData(_ encryptedPasswordText: String) -> String
}
