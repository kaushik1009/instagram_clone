//
//  PostTableViewCell.swift
//  Instagram Clone
//
//  Created by kaushik on 26/12/23.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postProfilePic: UIImageView!
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postOwner: UILabel!
    @IBOutlet weak var postParentView: UIView!
    @IBOutlet weak var addCommentView: UIView!
    @IBOutlet weak var captionStackView: UIStackView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet var postImageView: UIView!
    @IBOutlet weak var likeIcon: UIImageView!
    
    let activityIndicatorForPost = UIActivityIndicatorView(style: .large)
    let activityIndicatorForProfilePic = UIActivityIndicatorView(style: .medium)
    let mediaView = MediaView()
    var viewModel = HomeViewModel()
    var isLiked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeProfilePicsRound()
        addGestureToLikeIcon()
        embedMediaView()
        setupActivityIndicatorView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.addCommentView.isHidden = false
            NotificationCenter.default.post(name: NSNotification.Name("handleDynamicHeight"), object: nil, userInfo: ["height": (self?.postParentView.frame.size.height ?? 0) + 32])
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func embedMediaView() {
        mediaView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 197)
        self.postImageView.addSubview(mediaView)
    }
    
    private func makeProfilePicsRound() {
        postProfilePic.layer.masksToBounds = false
        postProfilePic.layer.cornerRadius = postProfilePic.frame.size.width / 2
        postProfilePic.clipsToBounds = true
        userProfilePic.layer.masksToBounds = false
        userProfilePic.layer.cornerRadius = userProfilePic.frame.size.width / 2
        userProfilePic.clipsToBounds = true
    }
    
    private func setupActivityIndicatorView() {
        activityIndicatorForPost.center =  CGPoint(x: self.postImageView.bounds.width / 2.5, y: self.postImageView.bounds.height / 2)
        activityIndicatorForProfilePic.center = CGPoint(x: self.postProfilePic.bounds.width / 2, y: self.postProfilePic.bounds.height / 2)
        self.postProfilePic.addSubview(activityIndicatorForProfilePic)
        self.postImageView.addSubview(activityIndicatorForPost)
    }
    
    func configureCell(_ data: PostData?) {
        activityIndicatorForPost.startAnimating()
//        viewModel.downloadImage(from: data?.imageUrl ?? "") { image in
//            DispatchQueue.main.async {
//                self.postImageView.image = image
//                self.activityIndicatorForPost.stopAnimating()
//            }
//        }
        if data?.videoUrl == "" {
            mediaView.imageURL = URL(string: data?.imageUrl ?? "")
        } else {
            mediaView.videoURL = URL(string: data?.videoUrl ?? "")
        }
        activityIndicatorForPost.stopAnimating()
        activityIndicatorForProfilePic.startAnimating()
        viewModel.downloadImage(from: URL(string: data?.profileImageUrl ?? "")!) { image in
            DispatchQueue.main.async {
                self.postProfilePic.image = image
                self.activityIndicatorForProfilePic.stopAnimating()
            }
        }
        self.postOwner.text = data?.postOwner
        self.captionLabel.text = "\(postOwner.text ?? "") \(data?.caption ?? "")"
        self.likesLabel.text = "\(data?.likes ?? 0) likes"
        self.timeStampLabel.text = data?.timeStamp
        self.commentCountLabel.isHidden = data?.comments.count ?? 0 <= 0 ? true : false
        self.commentCountLabel.text = "View all \(data?.comments.count ?? 0) comments"
        self.captionLabelDynamicSize()
    }
    
    private func captionLabelDynamicSize() {
        setupInitialCaptionLabel()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        captionLabel.isUserInteractionEnabled = true
        captionLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func addGestureToLikeIcon() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likeIcon.isUserInteractionEnabled = true
        likeIcon.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func labelTapped() {
        guard let indexPath = findIndexPath() else { return }
        updateLabel(indexPath)
        captionLabel.isUserInteractionEnabled = false
    }
    
    @objc func likeTapped() {
        isLiked = !isLiked
        var likes = self.likesLabel.text?.filter { $0.isNumber }.map { String($0) }.joined()
        if isLiked {
            UIView.transition(with: likeIcon, duration: 0.5, options: .transitionCurlDown) {
                self.likeIcon.image = UIImage(named: "heart_filled")
            }
            self.likesLabel.text = "\((Int(likes ?? "") ?? 0) + 1) likes"
        } else {
            self.likeIcon.image = UIImage(named: "heart")
            self.likesLabel.text = "\((Int(likes ?? "") ?? 0) - 1) likes"
        }
    }
    
    func setupInitialCaptionLabel() {
        let attributedString = NSMutableAttributedString(string: (captionLabel.text ?? ""))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14, weight: .semibold), range: NSRange(location: 0, length: (postOwner.text ?? "").count))
        if captionLabel.text?.count ?? 0 >= 50 {
            let shortText = String(attributedString.string.prefix(50))
            let attributedString1 = NSMutableAttributedString(string: shortText + " ... more")
            captionLabel.attributedText = attributedString1
        }
        captionLabel.numberOfLines = 2
    }
    
    func updateLabel(_ indexPath: IndexPath) {
        let attributedString = NSMutableAttributedString(string: (captionLabel.text ?? ""))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14, weight: .semibold), range: NSRange(location: 0, length: (postOwner.text ?? "").count))
        captionLabel.attributedText = attributedString
        captionLabel.numberOfLines = 0
    }
    
    private func findIndexPath() -> IndexPath? {
        var view = self.superview
        while let superView = view, !(superView is UITableView) {
            view = superView.superview
        }
        guard let tableView = view as? UITableView else { return nil }
        return tableView.indexPath(for: self)
    }
}
