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
        let vc = LoginVC.makeViewController()
        return vc
    }
}
