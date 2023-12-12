//
//  HomeVC.swift
//  LoginModule
//
//  Created by Keerthi Devipriya(kdp) on 12/12/23.
//

import UIKit

class HomeVC: UIViewController {
    var encryptedPswd: String = String()
    var validations: LoginValidation?
    
    enum Constant {
        static let margin: CGFloat = 16
    }
    
    lazy var baseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLbl: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 14)
        return lbl
    }()
    
    lazy var detailsLbl: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 18)
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    static func makeViewController(
        encryptedPswd: String,
        validations: LoginValidation?
    ) -> HomeVC {
        let vc = HomeVC()
        vc.validations = validations
        vc.encryptedPswd = encryptedPswd
        return vc
    }
    
    func configure() {
        setUpData()
        configureView()
        configureViewConstraints()
        configureViewTheme()
    }
    
    func setUpData() {
        titleLbl.text = "My details are as follows"
        detailsLbl.text = validations?.getDecryptData(self.encryptedPswd)
        // Utility.decryptData(self.encryptedPswd)
    }
    
    func configureView() {
        baseView.addSubview(titleLbl)
        baseView.addSubview(detailsLbl)
        view.addSubview(baseView)
    }
    
    func configureViewConstraints() {
        NSLayoutConstraint.activate([
            baseView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            baseView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            baseView.topAnchor.constraint(equalTo: self.view.topAnchor),
            baseView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            baseView.heightAnchor.constraint(equalToConstant: 370),
            
            titleLbl.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            titleLbl.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 408),
            
            detailsLbl.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            detailsLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: Constant.margin)
        ])
    }
    
    func configureViewTheme() {
        baseView.backgroundColor = .white
        self.view.backgroundColor = .white
    }
}
