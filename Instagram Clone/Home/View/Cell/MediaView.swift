//
//  MediaView.swift
//  Instagram Clone
//
//  Created by kaushik on 29/12/23.
//

import UIKit
import AVFoundation

class MediaView: UIView {
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var imageView: UIImageView?
    private var viewModel = HomeViewModel()
    
    private let activityIndicatorForPost = UIActivityIndicatorView(style: .large)
    
    var imageURL: URL? {
        didSet {
            if let url = imageURL {
                setupImageView(with: url)
            }
        }
    }
    
    var videoURL: URL? {
        didSet {
            if let url = videoURL {
                setupVideoPlayer(with: url)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        setupActivityIndicatorView()
    }

    private func setupActivityIndicatorView() {
        activityIndicatorForPost.center =  CGPoint(x: self.bounds.width / 2.5, y: self.bounds.height / 2)
        self.addSubview(activityIndicatorForPost)
    }
    
    private func setupImageView(with url: URL) {
        playerLayer?.removeFromSuperlayer()
        player = nil
        
        let imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        activityIndicatorForPost.startAnimating()
        viewModel.downloadImage(from: url) { image in
            DispatchQueue.main.async {
                imageView.image = image
            }
        }
        activityIndicatorForPost.stopAnimating()
        
        self.imageView = imageView
    }
    
    private func setupVideoPlayer(with url: URL) {
        imageView?.removeFromSuperview()
        activityIndicatorForPost.startAnimating()
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = self.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        
        if let playerLayer = playerLayer {
            layer.addSublayer(playerLayer)
        }
        activityIndicatorForPost.stopAnimating()
        player?.play()
    }
    
    func pauseVideo() {
        player?.pause()
    }
    
    func playVideo() {
        player?.play()
    }
    
    deinit {
        player?.pause()
        player = nil
    }
}
