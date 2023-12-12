//
//  BaseViewModel.swift
//  LoginModule
//
//  Created by Keerthi Devipriya(kdp) on 12/12/23.
//

import Foundation

public protocol LoginValidation {
    func makeTextEncrypted()
    func getDecryptedString()
}
