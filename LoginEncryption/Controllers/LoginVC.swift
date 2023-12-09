//
//  LoginVC.swift
//  LoginEncryption
//
//  Created by Keerthi Devipriya(kdp) on 09/12/23.
//

import UIKit

class LoginVC: UIViewController {
    
    lazy var titleLbl: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 14)
        return lbl
    }()
    
    lazy var submitBtn: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Submit", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
