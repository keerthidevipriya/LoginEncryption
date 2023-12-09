//
//  LoginVC.swift
//  LoginEncryption
//
//  Created by Keerthi Devipriya(kdp) on 09/12/23.
//

import UIKit

class LoginVC: UIViewController {
    lazy var baseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    static func makeViewController() -> LoginVC {
        let vc = LoginVC()
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        setUpData()
        configureView()
        configureViewConstraints()
        configureViewTheme()
    }
    
    func setUpData() {
        titleLbl.text = "Enter password"
        titleLbl.textColor = .black
        submitBtn.backgroundColor = .blue
    }
    
    func configureView() {
        baseView.addSubview(titleLbl)
        baseView.addSubview(submitBtn)
        view.addSubview(baseView)
    }
    
    func configureViewConstraints() {
        NSLayoutConstraint.activate([
            baseView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            baseView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            baseView.topAnchor.constraint(equalTo: self.view.topAnchor),
            baseView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            baseView.heightAnchor.constraint(equalToConstant: 270),
            
            titleLbl.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            titleLbl.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 408),
            
            submitBtn.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            submitBtn.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 16)
        ])
    }
    
    func configureViewTheme() {
        baseView.backgroundColor = .white
        self.view.backgroundColor = .white
    }

}
