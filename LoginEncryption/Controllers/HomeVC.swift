//
//  HomeVC.swift
//  LoginEncryption
//
//  Created by Keerthi Devipriya(kdp) on 09/12/23.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
    }
    
    static func makeViewController() -> HomeVC {
        let vc = HomeVC()
        return vc
    }
}
