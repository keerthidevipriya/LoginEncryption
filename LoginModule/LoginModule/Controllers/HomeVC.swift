//
//  HomeVC.swift
//  LoginModule
//
//  Created by Keerthi Devipriya(kdp) on 12/12/23.
//

import UIKit

class HomeVC: UIViewController {
    var defaults = UserDefaults.standard
    var encryptedPswd: String = String()
    var validations: LoginValidation?
    
    enum Constant {
        static let margin: CGFloat = 48
        static let iconMargin: CGFloat = 72
        static let lockIcon = UIImage(named: "lockIcon")
        static let verified_yes = UIImage(named: "verify_yes")
        static let verified_no = UIImage(named: "verify_no")
        static let bgImage = UIImage(named: "bluegradientbgImage") ?? UIImage()
    }
    
    lazy var baseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var lockImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = Constant.lockIcon
        imageView.center = view.center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var bgImageView : UIImageView = {
        var imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = Constant.bgImage
        imageView.center = view.center
        return imageView
    }()
    
    lazy var titleLbl: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 24)
        return lbl
    }()
    
    lazy var detailsLbl: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 20)
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
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
        let isVerified = defaults.bool(forKey: Keys.biometric.rawValue)
        lockImageView.image = isVerified ? Constant.verified_yes : Constant.verified_no
        titleLbl.text = "My details are as follows"
        detailsLbl.text = validations?.getDecryptData(self.encryptedPswd)
        // Utility.decryptData(self.encryptedPswd)
    }
    
    func configureView() {
        baseView.addSubview(lockImageView)
        baseView.addSubview(titleLbl)
        baseView.addSubview(detailsLbl)
        view.addSubview(bgImageView)
        view.addSubview(baseView)
    }
    
    func configureViewConstraints() {
        NSLayoutConstraint.activate([
            baseView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            baseView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            baseView.topAnchor.constraint(equalTo: self.view.topAnchor),
            baseView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            baseView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            lockImageView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            lockImageView.widthAnchor.constraint(equalToConstant: Constant.iconMargin),
            lockImageView.heightAnchor.constraint(equalToConstant: Constant.iconMargin),
            lockImageView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 370),
            
            titleLbl.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            titleLbl.topAnchor.constraint(equalTo: lockImageView.bottomAnchor, constant: Constant.margin),
            
            detailsLbl.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            detailsLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: Constant.margin)
        ])
    }
    
    func configureViewTheme() {
        titleLbl.textColor = .white
        detailsLbl.textColor = .white
    }
}
