//
//  LoginVC.swift
//  LoginModule
//
//  Created by Keerthi Devipriya(kdp) on 12/12/23.
//

import UIKit
import LocalAuthentication

public class LoginVC: UIViewController {
    var defaults = UserDefaults.standard
    var encryptedPswd: String = String()
    var validations: LoginValidation?
    
    enum Constant {
        static let margin: CGFloat = 48
        static let btnHeight: CGFloat = 48
        static let sideMargin: CGFloat = 64
        static let bgImage = UIImage(named: "bluegradientbgImage") ?? UIImage()
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
        lbl.font = UIFont.systemFont(ofSize: 24)
        return lbl
    }()
    
    lazy var pswdTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter Password"
        textField.clipsToBounds = true
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.backgroundColor = .lightGray
        textField.textColor = .black
        textField.isSecureTextEntry = true
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        // textField.addTarget(self, action: #selector(saveDetails), for: .editingChanged)
        return textField
    }()
    
    lazy var biometricSwitch: UISwitch = {
        var s = UISwitch()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.addTarget(self, action: #selector(self.switchValueDidChange), for: .valueChanged)
        return s
    }()
    
    lazy var enableBiometricsLbl: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 16)
        return lbl
    }()
    
    lazy var submitBtn: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Submit", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        btn.layer.cornerRadius = 16
        return btn
    }()
    
    lazy var clearBtn: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Clear", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    lazy var imageView : UIImageView = {
        var imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = Constant.bgImage
        imageView.center = view.center
        return imageView
    }()
    
    var timer = Timer()
    let timeInterval: TimeInterval = 5.0
    var workout = false
    var workoutIntervalCount = 5
    var seconds: TimeInterval = 0.0
    var backgroundTask: UIBackgroundTaskIdentifier?
    
    func startTimer() {
        if !timer.isValid { //prevent more than one timer on the thread
            backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
            timer = Timer.scheduledTimer(
                timeInterval: timeInterval,
                target: self,
                selector: #selector(timerDidEnd),
                userInfo: nil,
                repeats: true)
            
        }
    }
    
    @objc func timerDidEnd(timer: Timer) {
        //decrement the counter
        if workoutIntervalCount == 0 { //finshed intervals
            timer.invalidate()
            //clearBtn.text = "Sent Notification"
            guard let bgTask = backgroundTask else { return }
            UIApplication.shared.endBackgroundTask(bgTask)
        } else {
            workout = !workout
            if !workout {
                //clearBtn.text = String(format:"Interval %i Rest",workoutIntervalCount)
                workoutIntervalCount -= 1
            }else{
                workoutIntervalCount = 0
                //clearBtn.text = String(format:"Interval %i Work Out",workoutIntervalCount)
            }
            
        }
        let localNotification = UILocalNotification()
        localNotification.alertBody = "Tap me"//statusLabel.text!
        localNotification.timeZone = NSTimeZone.default
        localNotification.applicationIconBadgeNumber = workoutIntervalCount
        
        //set the notification
        UIApplication.shared.presentLocalNotificationNow(localNotification)
        workoutIntervalCount = 0
    }
    
    public static func makeViewController(validations: LoginValidation?) -> LoginVC {
        let vc = LoginVC()
        vc.validations = validations
        vc.encryptedPswd = validations?.getDecryptData(vc.defaults.string(forKey: Keys.password.rawValue) ?? String()) ?? String()
        //Utility.decryptData(vc.defaults.string(forKey: Keys.password.rawValue) ?? String())
        return vc
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        loadData()
        configure()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // pswdTextField.addTarget(self, action: #selector(saveDetails), for: .editingChanged)
    }
    
    func configure() {
        setUpData()
        configureView()
        configureViewConstraints()
        configureViewTheme()
    }
    
    func setUpData() {
        titleLbl.text = "Please enter your password"
        enableBiometricsLbl.text = "Enable Biometrics"
        titleLbl.textColor = .black
        submitBtn.backgroundColor = .blue//UIColor(hex: "#2C64C6")
        clearBtn.backgroundColor = .blue
    }
    
    func configureView() {
        
        baseView.addSubview(titleLbl)
        baseView.addSubview(pswdTextField)
        baseView.addSubview(submitBtn)
        baseView.addSubview(biometricSwitch)
        baseView.addSubview(enableBiometricsLbl)
        //baseView.addSubview(clearBtn)
        view.addSubview(imageView)
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
            titleLbl.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 308),
            
            pswdTextField.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: Constant.sideMargin),
            pswdTextField.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -Constant.sideMargin),
            pswdTextField.heightAnchor.constraint(equalToConstant: Constant.btnHeight),
            pswdTextField.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: Constant.margin),
            
            submitBtn.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: Constant.sideMargin),
            submitBtn.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -Constant.sideMargin),
            submitBtn.heightAnchor.constraint(equalToConstant: Constant.btnHeight),
            submitBtn.topAnchor.constraint(equalTo: pswdTextField.bottomAnchor, constant: Constant.margin),
            
            biometricSwitch.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            biometricSwitch.topAnchor.constraint(equalTo: submitBtn.bottomAnchor, constant: Constant.margin),
            
            enableBiometricsLbl.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            enableBiometricsLbl.topAnchor.constraint(equalTo: biometricSwitch.bottomAnchor, constant: 8)
            //enableBiometricsLbl.widthAnchor.constraint(equalToConstant: Constant.btnWidth)
        ])
    }
    
    func configureViewTheme() {
        pswdTextField.layer.cornerRadius = 12
        titleLbl.textColor = .white
        enableBiometricsLbl.textColor = .white
        //self.view.backgroundColor = UIColor(patternImage: imageView.image ?? UIImage())
        //baseView.backgroundColor = UIColor(patternImage: Constant.bgImage)
    }
}

extension LoginVC {
    @objc func submitTapped() {
        handleNotification()
        if let pswd = pswdTextField.text, !pswd.isEmpty {
            validations?.makeEncryptData(pswd, completion: { (encryptedPswd, data) in
                self.encryptedPswd = encryptedPswd
                self.saveDetails()
                self.navigateToHomeVC(encryptedPswd)
            })
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
        if let data = defaults.string(forKey: Keys.password.rawValue) {
            pswdTextField.text = validations?.getDecryptData(data)
        }
        biometricSwitch.isOn = defaults.bool(forKey: Keys.biometric.rawValue)
        if biometricSwitch.isOn {
            self.submitTapped()
        }
    }
    
    @objc func saveDetails() {
        defaults.set(encryptedPswd, forKey: Keys.password.rawValue)
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
    
    func navigateToHomeVC(_ encryptedPswd: String) {
        let vc = HomeVC.makeViewController(
            encryptedPswd: encryptedPswd,
            validations: validations
        )
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleNotification() {
        startTimer()
    }
}
