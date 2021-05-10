//
//  ResetViewController.swift
//  DemoLogin
//
//  Created by Peiru Chiu on 2021/5/5.
//  Copyright © 2021 Peiru Chiu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAnalytics

class ResetViewController: UIViewController {
    
    var emailTxtFld: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "重設密碼"
        self.view.backgroundColor = .white
        
        // 生成email輸入框
        self.emailTxtFld = UITextField()
        self.emailTxtFld.frame = CGRect(x: self.view.frame.size.width / 2 / 2, y: self.view.frame.size.height / 2 - 15 - 10 - 64, width: self.view.frame.size.width / 2, height: 30)
        self.emailTxtFld.font = UIFont.systemFont(ofSize: 20)
        self.emailTxtFld.borderStyle = .roundedRect
        self.emailTxtFld.backgroundColor = UIColor.white
        self.emailTxtFld.textAlignment = NSTextAlignment.left
        self.emailTxtFld.clearButtonMode = .unlessEditing // 清除按鈕
        self.emailTxtFld.keyboardType = .emailAddress
        self.emailTxtFld.returnKeyType = .done
        self.emailTxtFld.placeholder = "請輸入email"
        self.view.addSubview(self.emailTxtFld)
        
        // 生成重設按鈕
        let resetBtn: UIButton = UIButton()
        resetBtn.frame = CGRect(x: self.view.frame.size.width / 2 / 2, y: emailTxtFld.frame.origin.y + emailTxtFld.frame.size.height + 20, width: self.view.frame.size.width / 2, height: 30)
        resetBtn.titleLabel?.font = UIFont.systemFont(ofSize: resetBtn.frame.height * 0.8)
        resetBtn.setTitle("重設", for: .normal)
        resetBtn.setTitleColor(UIColor.white, for: .normal)
        resetBtn.layer.cornerRadius = 10
        resetBtn.backgroundColor = UIColor.lightGray
        resetBtn.addTarget(self, action: #selector(onClickRegister(_:)), for: .touchUpInside)
        self.view.addSubview(resetBtn)
        
        // 註冊tab事件，點選瑩幕任一處可關閉瑩幕小鍵盤
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    // MARK: - Callback
    // ---------------------------------------------------------------------
    // 重設密碼
    @objc func onClickRegister(_ sender: UIButton) {
        // email為必填欄位
               if self.emailTxtFld.text == "" {
                   self.showMsg("請輸入email")
                   return
               }
               
        Auth.auth().sendPasswordReset(withEmail: self.emailTxtFld.text!, completion: { (error) in
                   // 重設失敗
                   if error != nil {
                       self.showMsg((error?.localizedDescription)!)
                       return
                   }
                   
                   self.showMsg("重設成功，請檢查信箱信件")
               })
    }
    
    // 關閉瑩幕小鍵盤
    func dismissKeyboard() {
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
