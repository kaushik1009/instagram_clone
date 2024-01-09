//
//  StoryTableViewCell.swift
//  Instagram Clone
//
//  Created by kaushik on 30/12/23.
//

import UIKit

class StoryTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var storyCollectionView: UICollectionView!
    
    var viewModel = HomeViewModel()
    var storyArray: Story? {
        didSet {
            self.storyCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        storyCollectionView.dataSource = self
        storyCollectionView.delegate = self
        storyArray = viewModel.fetchStories()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storyArray?.stories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storyCollectionView", for: indexPath) as! StoryCollectionViewCell
        cell.configureCell(storyArray?.stories[indexPath.row], indexPath.row)
        return cell
    }

}
