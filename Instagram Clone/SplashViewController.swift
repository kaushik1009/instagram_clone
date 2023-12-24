//
//  ViewController.swift
//  Instagram Clone
//
//  Created by kaushik on 23/12/23.
//

import UIKit

class SplashViewController: UIViewController {

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoImageView)
        view.backgroundColor = .black
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logoImageView.center = view.center
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animate()
        }
    }
    
    private func animate() {
        UIView.animate(withDuration: 1) {
            let size = self.view.frame.size.width * 3
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            self.logoImageView.frame = CGRect(x: -(diffX/2), y: diffY/2, width: size, height: size)
        }
        UIView.animate(withDuration: 1, animations: {
            self.logoImageView.alpha = 0
        }, completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
                    self.present(loginViewController, animated: true, completion: nil)
                }
            }
        })
    }
}
