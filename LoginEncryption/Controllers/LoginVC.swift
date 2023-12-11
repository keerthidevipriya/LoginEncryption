//
//  LoginVC.swift
//  LoginEncryption
//
//  Created by Keerthi Devipriya(kdp) on 09/12/23.
//

import LocalAuthentication
import UIKit

class LoginVC: UIViewController {
    var defaults = UserDefaults.standard
    
    enum Constant {
        static let margin: CGFloat = 16
        static let btnWidth: CGFloat = 64
    }
    enum Keys: String {
        case password
        case biometric
    }
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
    
    lazy var pswdTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter Password"
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.backgroundColor = .lightGray
        textField.textColor = .gray
        textField.isSecureTextEntry = true
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.addTarget(self, action: #selector(saveDetails), for: .editingChanged)
        return textField
    }()
    
    lazy var biometricSwitch: UISwitch = {
        var s = UISwitch()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.addTarget(self, action: #selector(self.switchValueDidChange), for: .valueChanged)
        return s
    }()
    
    lazy var submitBtn: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Submit", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    lazy var clearBtn: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Clear", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    static func makeViewController() -> LoginVC {
        let vc = LoginVC()
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        loadData()
        pswdTextField.addTarget(self, action: #selector(saveDetails), for: .editingChanged)
        configure()
    }
    
    func configure() {
        setUpData()
        configureView()
        configureViewConstraints()
        configureViewTheme()
    }
    
    func setUpData() {
        titleLbl.text = "Welcome"
        titleLbl.textColor = .black
        submitBtn.backgroundColor = .blue
        clearBtn.backgroundColor = .blue
    }
    
    func configureView() {
        baseView.addSubview(titleLbl)
        baseView.addSubview(pswdTextField)
        baseView.addSubview(submitBtn)
        baseView.addSubview(biometricSwitch)
        baseView.addSubview(clearBtn)
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
            
            pswdTextField.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            pswdTextField.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: Constant.margin),
            
            submitBtn.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            submitBtn.widthAnchor.constraint(equalToConstant: Constant.btnWidth),
            submitBtn.topAnchor.constraint(equalTo: pswdTextField.bottomAnchor, constant: Constant.margin),
            
            biometricSwitch.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            biometricSwitch.topAnchor.constraint(equalTo: submitBtn.bottomAnchor, constant: Constant.margin),
            
            clearBtn.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            clearBtn.topAnchor.constraint(equalTo: biometricSwitch.bottomAnchor, constant: Constant.margin),
            clearBtn.widthAnchor.constraint(equalToConstant: Constant.btnWidth)
        ])
    }
    
    func configureViewTheme() {
        baseView.backgroundColor = .white
        self.view.backgroundColor = .white
    }
}

extension LoginVC {
    @objc func submitTapped() {
        handleNotification()
        if !(pswdTextField.text?.isEmpty ?? true) {
            self.saveDetails()
            self.navigateToHomeVC()
        } else {
            self.showPasswordEmptyAlert()
        }
    }
    
    @objc func clearTapped() {
        pswdTextField.text = String()
        biometricSwitch.isOn = false
        UserDefaults.standard.removeObject(forKey: Keys.password.rawValue)
        UserDefaults.standard.removeObject(forKey: Keys.biometric.rawValue)
    }
    
    func loadData() {
        pswdTextField.text = defaults.string(forKey: Keys.password.rawValue)
        biometricSwitch.isOn = defaults.bool(forKey: Keys.biometric.rawValue)
        /*if biometricSwitch.isOn {
            self.navigateToHomeVC()
        }*/
    }
    
    @objc func saveDetails() {
        defaults.set(pswdTextField.text!, forKey: Keys.password.rawValue)
        defaults.set(biometricSwitch.isOn, forKey: Keys.biometric.rawValue)
    }
    
    func showPasswordEmptyAlert() {
        let ac = UIAlertController(title: "Oops Password is empty", message: "Please enter password and try again!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(ac, animated: true)
    }
    
    func addBiometricAuthentication() {
        let context = LAContext()
        var error: NSError? = nil
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authorize with touchID!"
            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            ) { [weak self] succs, err in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    guard succs, err == nil else {
                        self.showAuthfailedAlert()
                        return
                    }
                    self.showBiometricsSuccessAlert()
                }
            }
        } else {
            self.showNoBiometricAvailable()
        }
    }
    
    func showBiometricsSuccessAlert() {
        let ac = UIAlertController(title: "Wohoo!!", message: "Biometrics added successfully", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(ac, animated: true)
    }
    
    func showAuthfailedAlert() {
        biometricSwitch.isOn = false
        let ac = UIAlertController(title: "Authentication failed", message: "Please try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(ac, animated: true)
    }
    
    func showNoBiometricAvailable() {
        biometricSwitch.isOn = false
        let ac = UIAlertController(
            title: "Biometry unavailable",
            message: "Your device is not configured for biometric authentication.",
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(ac, animated: true)
    }
    
    @objc func switchValueDidChange(sender:UISwitch!) {
        if(sender.isOn) {
            self.addBiometricAuthentication()
        }
    }
    
    func navigateToHomeVC() {
        let vc = HomeVC.makeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleNotification() {
        let notification = UILocalNotification()
        notification.alertAction = "Hello"
        notification.alertBody = "Welcome to the app!"
        
        notification.fireDate = Date(timeIntervalSinceNow: 0)
        notification.soundName = UILocalNotificationDefaultSoundName
        
        notification.userInfo = ["title": "Title", "UUID": "12345"]
        UIApplication.shared.scheduleLocalNotification(notification)
    }
}
