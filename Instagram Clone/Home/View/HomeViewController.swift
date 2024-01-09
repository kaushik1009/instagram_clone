//
//  HomeViewController.swift
//  Instagram Clone
//
//  Created by kaushik on 26/12/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var postTableView: UITableView!
    
    var viewModel = HomeViewModel()
    var postArray: Post? {
        didSet {
            self.postTableView.reloadData()
        }
    }
    var cellHeights: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postArray = viewModel.fetchPosts()
        self.setupTableViewAndCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(handleDynamicHeight(_:)), name: NSNotification.Name("handleDynamicHeight"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDynamicHeightWhenCaptionClicked(_:)), name: NSNotification.Name("handleDynamicHeightWhenCaptionClicked"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupTableViewAndCollectionView() {
        cellHeights = Array(repeating: 416, count: postArray?.posts.count ?? 0)
        postTableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "postTableView")
        postTableView.dataSource = self
        postTableView.delegate = self
    }
    
    @objc func handleDynamicHeight(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let newHeight = userInfo["height"] as? CGFloat {
                for i in 0..<cellHeights.count {
                    cellHeights[i] = newHeight
                }
                self.postTableView.reloadData()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name("handleDynamicHeight"), object: nil)
            }
        }
    }
    
    @objc func handleDynamicHeightWhenCaptionClicked(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let newHeight = userInfo["height"] as? CGFloat, let indexpath = userInfo["indexPath"] as? IndexPath {
                cellHeights[indexpath.row] = newHeight
                self.postTableView.reloadData()
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : postArray?.posts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "storyTableView", for: indexPath) as! StoryTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postTableView", for: indexPath) as! PostTableViewCell
            cell.configureCell(postArray?.posts[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 128 : cellHeights[indexPath.row]
    }
}
