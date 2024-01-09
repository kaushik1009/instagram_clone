//
//  LoginViewController.swift
//  Instagram Clone
//
//  Created by kaushik on 25/12/23.
//

import UIKit

class LoginViewController:UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginButton()
        setupSignUpLabel()
    }
    
    private func setupLoginButton() {
        loginButton.layer.cornerRadius = 16
    }
    
    private func setupSignUpLabel() {
        let attributedString = NSMutableAttributedString(string: signUpLabel.text ?? "")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 0, length: 22))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.link, range: NSRange(location: 23, length: 7))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: NSRange(location: 23, length: 7))
        signUpLabel.attributedText = attributedString
    }
}
