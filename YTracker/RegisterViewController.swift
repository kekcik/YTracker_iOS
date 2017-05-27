//
//  RegisterViewController.swift
//  YTracker
//
//  Created by Ivan Trofimov on 23.05.17.
//  Copyright © 2017 Ivan Trofimov. All rights reserved.
//

import UIKit
import Material
import Foundation
import TTGSnackbar
class RegisterViewController: UIViewController, TextFieldDelegate {

    @IBOutlet weak var loginTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: TextField!
    @IBOutlet weak var phoneTextField: TextField!
    @IBOutlet weak var pwTextField: TextField!
    @IBOutlet weak var pw2TextField: TextField!
    @IBOutlet weak var stackViewWithFields: UIStackView!
    @IBOutlet weak var underButtonConstrain: NSLayoutConstraint!
    @IBOutlet weak var underStackConstrain: NSLayoutConstraint!
    fileprivate var undoButton: FlatButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setConstrains()
        presets()
        registerSignUpNotification()
        registerKeyboardNotification()
    }
    
    deinit {
        removeKeyboardNotification()
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        nameTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        pwTextField.resignFirstResponder()
        pw2TextField.resignFirstResponder()
        
        if (validateFileds()) {
            let snackbar = TTGSnackbar.init(message: "Какое-то поле заполнено неправильно", duration: .middle, actionText: "Понятно") { (snackbar) -> Void in
                NSLog("Click action!")
            }
            snackbar.animationType = .slideFromTopBackToTop
            snackbar.show()
        } else {
            AccountManager.sh.register(name: nameTextField.text!, phone: phoneTextField.text!, pw: pwTextField.text!)
        }
    }
    
    func setDetailFor(textField: TextField, arg : Bool, det: String) -> Bool {
        if (arg) {
            textField.detail = det
            return arg
        } else {
            textField.detail = ""
            return arg
        }
    }
    
    func validateFileds() -> Bool {
        var flag = false
        flag = !flag ? setDetailFor(textField: nameTextField, arg: (nameTextField.text == ""), det: "Неправильный логин") : true
        flag = !flag ? setDetailFor(textField: phoneTextField, arg: (phoneTextField.text == ""), det: "Неправильный формат номера") : true
        flag = !flag ? setDetailFor(textField: pwTextField, arg: (pwTextField.text!.characters.count == 0), det: "Неправильный пароль") : true
        flag = !flag ? setDetailFor(textField: pw2TextField, arg: (pw2TextField.text != pwTextField.text), det: "Пароли не совпадают") : true
        return flag
    }
    
    func registerSignUpNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(validationPhoneError), name: Notification.Name("registerWrongPhone"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(successRegister), name: Notification.Name("registerSuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(failRegister), name: Notification.Name("registerFail"), object: nil)
    }
    
    func failRegister(notification: Notification) {
        let snackbar = TTGSnackbar.init(message: "Что-то пошло не так", duration: .middle, actionText: "Понятно") { (snackbar) -> Void in
            NSLog("Click action!")
        }
        snackbar.animationType = .slideFromTopBackToTop
        snackbar.show()
    }
    
    func successRegister(notification: Notification) {
        print(notification.object as! String)
    }
    
    func validationPhoneError(notification: Notification) {
        print("aaa")
        phoneTextField.detail = "Этот телефон уже используется"
    }
}

extension RegisterViewController {
    func presets() {
        let color = UIColor.red
        nameTextField.detailColor = color
        phoneTextField.detailColor = color
        pwTextField.detailColor = color
        pw2TextField.detailColor = color
        
    }
    func setConstrains() {
        
        underStackConstrain.constant = 40
        underButtonConstrain.constant = 60
        loginTitleHeight.constant = 330
        stackViewWithFields.spacing = CGFloat(42)
    }
}

extension RegisterViewController {
    func registerKeyboardNotification () {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height)
    }
    
    func kbWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
}
