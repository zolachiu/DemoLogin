//
//  ViewController.swift
//  DemoLogin
//
//  Created by Peiru Chiu on 2021/5/5.
//  Copyright © 2021 Peiru Chiu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAnalytics

class ViewController: UIViewController {
    
    var userAccountLabel: UILabel!
    var emailTxtFld: UITextField!
    var passwordTxtFld: UITextField!
    var registerViewController: RegisterViewController?
    var resetViewController: ResetViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // 設定導覽列的Title
        self.navigationItem.title = "登入"
        
        self.userAccountLabel = UILabel()
        self.userAccountLabel.text = "尚未登入"
        self.userAccountLabel.textAlignment = .right
        self.userAccountLabel.frame = CGRect(x:self.view.frame.size.width - self.view.frame.size.height, y: (self.navigationController?.navigationBar.frame.size.height)! + 20 , width: self.view.frame.size.height, height: 30)
        self.view.addSubview(userAccountLabel)
        
        
        
        // 生成email輸入框
        self.emailTxtFld = UITextField()
        self.emailTxtFld.frame = CGRect(x: self.view.frame.size.width / 2 / 2, y: self.view.frame.size.height / 2 - 15 - 10 - 64, width: self.view.frame.size.width / 2, height: 30)
        self.emailTxtFld.font = UIFont.systemFont(ofSize: 20)
        self.emailTxtFld.borderStyle = .roundedRect // 輸入框的樣式
        self.emailTxtFld.backgroundColor = UIColor.white
        self.emailTxtFld.textAlignment = NSTextAlignment.left
        self.emailTxtFld.clearButtonMode = .unlessEditing // 清除按鈕
        self.emailTxtFld.keyboardType = .emailAddress
        self.emailTxtFld.returnKeyType = .done
        self.emailTxtFld.placeholder = "請輸入email" //尚未輸入時的預設顯示提示文字
        self.view.addSubview(self.emailTxtFld)
        
        // 生成密碼輸入框
        self.passwordTxtFld = UITextField()
        self.passwordTxtFld.frame = CGRect(x: self.view.frame.size.width / 2 / 2, y: emailTxtFld.frame.origin.y + emailTxtFld.frame.size.height + 20, width: self.view.frame.size.width / 2, height: 30)
        self.passwordTxtFld.font = UIFont.systemFont(ofSize: 20)
        self.passwordTxtFld.borderStyle = .roundedRect
        self.passwordTxtFld.backgroundColor = UIColor.white
        self.passwordTxtFld.textAlignment = NSTextAlignment.left
        self.passwordTxtFld.clearButtonMode = .unlessEditing // 清除按鈕
        self.passwordTxtFld.returnKeyType = .done
        self.passwordTxtFld.placeholder = "請輸入密碼"
        self.view.addSubview(self.passwordTxtFld)
        
        // 生成登入按鈕
        let loginBtn: UIButton = UIButton()
        loginBtn.frame = CGRect(x: self.view.frame.size.width / 2 / 2, y: passwordTxtFld.frame.origin.y + passwordTxtFld.frame.size.height + 20, width: self.view.frame.size.width / 2, height: 30)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: loginBtn.frame.height * 0.8)
        loginBtn.setTitle("登入", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.layer.cornerRadius = 10
        loginBtn.backgroundColor = UIColor.lightGray
        loginBtn.addTarget(self, action: #selector(onClickLogin(_:)), for:.touchUpInside)
        self.view.addSubview(loginBtn)
        
        // 生成註冊按鈕
        let registerBtn: UIButton = UIButton()
        registerBtn.frame = CGRect(x: self.view.frame.size.width / 2 / 2, y: loginBtn.frame.origin.y + passwordTxtFld.frame.size.height + 20, width: self.view.frame.size.width/2, height: 30)
        registerBtn.titleLabel?.font = UIFont.systemFont(ofSize: registerBtn.frame.height * 0.8)
        registerBtn.setTitle("註冊", for: .normal)
        registerBtn.setTitleColor(UIColor.white, for: .normal)
        registerBtn.layer.cornerRadius = 10
        registerBtn.backgroundColor = UIColor.lightGray
        registerBtn.addTarget(self, action: #selector(onClickRegister(_:)), for:.touchUpInside)
        self.view.addSubview(registerBtn)
        
        // 生成重設密碼按鈕
        let resetBtn: UIButton = UIButton()
        resetBtn.frame = CGRect(x: self.view.frame.size.width / 2 / 2, y: registerBtn.frame.origin.y + registerBtn.frame.size.height + 20, width: self.view.frame.size.width / 2, height: 30)
        resetBtn.titleLabel?.font = UIFont.systemFont(ofSize: resetBtn.frame.height * 0.8)
        resetBtn.setTitle("重設密碼", for: .normal)
        resetBtn.setTitleColor(UIColor.white, for: .normal)
        resetBtn.layer.cornerRadius = 10
        resetBtn.backgroundColor = UIColor.lightGray
        passwordTxtFld.isSecureTextEntry = true
        resetBtn.addTarget(self, action: #selector(onClickReset(_:)), for:.touchUpInside)
        self.view.addSubview(resetBtn)
        
        // 生成登出按鈕
        let logoutBtn: UIButton = UIButton()
        logoutBtn.frame = CGRect(x: self.view.frame.size.width / 2 / 2, y: resetBtn.frame.origin.y + resetBtn.frame.size.height + 20, width: self.view.frame.size.width / 2, height: 30)
        logoutBtn.titleLabel?.font = UIFont.systemFont(ofSize: logoutBtn.frame.height * 0.8)
        logoutBtn.setTitle("登出", for: .normal)
        logoutBtn.setTitleColor(UIColor.white, for: .normal)
        logoutBtn.layer.cornerRadius = 10
        logoutBtn.backgroundColor = UIColor.lightGray
        logoutBtn.addTarget(self, action: #selector(onClickLogout(_:)), for:.touchUpInside)
        self.view.addSubview(logoutBtn)
        
        Auth.auth().addStateDidChangeListener{ (auth, user) in
            if user != Auth.auth().currentUser{
                self.userAccountLabel.text = "使用者：" + (self.emailTxtFld.text ?? "訪客")
            }
        }

        // 註冊tab事件，點選瑩幕任一處可關閉瑩幕小鍵盤
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    // MARK: - Callback
    // ---------------------------------------------------------------------
    // 登入
    @objc  func onClickLogin(_ sender: UIButton) {
        // email和密碼為必填欄位
               if self.emailTxtFld.text == "" || self.passwordTxtFld.text == "" {
                   self.showMsg("請輸入email和密碼")
                   return
               }
               
        Auth.auth().signIn(withEmail: self.emailTxtFld.text!, password: self.passwordTxtFld.text!) { [self] (user, error) in
                   
                   // 登入失敗
                   if error != nil {
                       self.showMsg((error?.localizedDescription)!)
                       return
                   }
                   
                   // 登入成功並顯示已登入
                self.showMsg("登入成功")
                self.userAccountLabel.text = "使用者：" + (self.emailTxtFld.text ?? "訪客")

               }
        
    }
    
    // 登出
    @objc  func onClickLogout(_ sender: UIButton) {
        // 未登入
        if Auth.auth().currentUser == nil {
                   self.showMsg("未登入")
               }
                        
               do {
                try Auth.auth().signOut()
                   self.showMsg("登出成功")
                self.userAccountLabel.text = "尚未登入"
               } catch let error as NSError {
                   self.showMsg(error.localizedDescription)
               }
        
    }
    
    // 註冊
    @objc  func onClickRegister(_ sender: UIButton) {
        self.registerViewController = RegisterViewController()
        self.navigationController?.pushViewController(self.registerViewController!, animated: true)
    }
    
    // 重設密碼
    @objc  func onClickReset(_ sender: UIButton) {
        self.resetViewController = ResetViewController()
        self.navigationController?.pushViewController(self.resetViewController!, animated: true)
    }
    
    // 關閉瑩幕小鍵盤
    @objc  func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // 提示錯誤訊息
    func showMsg(_ message: String) {
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "確定", style: .default, handler: nil)
        
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
