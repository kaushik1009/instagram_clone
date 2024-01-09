//
//  StoryCollectionViewCell.swift
//  Instagram Clone
//
//  Created by kaushik on 30/12/23.
//

import UIKit

class StoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var storyOwnerProfilePic: UIImageView!
    @IBOutlet weak var storyOwnerName: UILabel!
    @IBOutlet weak var addStoryButton: UIButton!
    
    let viewModel = HomeViewModel()
    let activityIndicatorForStory = UIActivityIndicatorView(style: .large)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeStoryOwnerProfilePicRound()
        setupActivityIndicatorView()
    }
    
    private func makeStoryOwnerProfilePicRound() {
        storyOwnerProfilePic.layer.masksToBounds = false
        storyOwnerProfilePic.layer.cornerRadius = 35
        storyOwnerProfilePic.clipsToBounds = true
    }
    
    func configureCell(_ storyData: StoryData?, _ index: Int) {
        activityIndicatorForStory.startAnimating()
        viewModel.downloadImage(from: URL(string: storyData?.profileImageUrl ?? "")!) { image in
            DispatchQueue.main.async {
                if index == 0 {
                    self.storyOwnerProfilePic.image = UIImage(named: "profile_pic")
                    self.storyOwnerName.text = "Your Story"
                    self.addStoryButton.isHidden = false
                } else {
                    self.storyOwnerProfilePic.image = image
                    self.storyOwnerName.text = storyData?.storyOwner
                    self.addStoryButton.isHidden = true
                }
                self.activityIndicatorForStory.stopAnimating()
            }
        }
        if (!(storyData?.isOpened ?? false) && index != 0) {
            addBorderGradient(to: storyOwnerProfilePic, startColor: UIColor.purple, endColor: UIColor.orange, lineWidth: 5, startPoint: CGPoint.topLeft, endPoint: CGPoint.bottomRight)
        }
    }
    
    private func setupActivityIndicatorView() {
        activityIndicatorForStory.center =  CGPoint(x: self.storyOwnerProfilePic.bounds.width / 2.5, y: self.storyOwnerProfilePic.bounds.height / 2)
        self.storyOwnerProfilePic.addSubview(activityIndicatorForStory)
    }
    
    private func addBorderGradient(to view: UIView, startColor:UIColor, endColor: UIColor, lineWidth: CGFloat, startPoint: CGPoint, endPoint: CGPoint) {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        let shape = CAShapeLayer()
        shape.lineWidth = lineWidth
        shape.path = UIBezierPath(
            arcCenter: CGPoint(x: 35,
                               y: 35),
            radius: 35,
            startAngle: CGFloat(0),
            endAngle:CGFloat(CGFloat.pi * 2),
            clockwise: true).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        view.layer.addSublayer(gradient)
    }
}

extension CGPoint {
    static let topLeft = CGPoint(x: 0, y: 0)
    static let topCenter = CGPoint(x: 0.5, y: 0)
    static let topRight = CGPoint(x: 1, y: 0)
    static let centerLeft = CGPoint(x: 0, y: 0.5)
    static let center = CGPoint(x: 0.5, y: 0.5)
    static let centerRight = CGPoint(x: 1, y: 0.5)
    static let bottomLeft = CGPoint(x: 0, y: 1.0)
    static let bottomCenter = CGPoint(x: 0.5, y: 1.0)
    static let bottomRight = CGPoint(x: 1, y: 1)
}
