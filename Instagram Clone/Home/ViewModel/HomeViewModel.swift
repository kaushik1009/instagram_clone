//
//  HomeViewModel.swift
//  Instagram Clone
//
//  Created by kaushik on 28/12/23.
//

import Foundation
import UIKit

class HomeViewModel {
    
    func fetchPosts() -> Post? {
        if let url = Bundle.main.url(forResource: "posts", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let results = try JSONDecoder().decode(Post.self, from: data)
                return results
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        return nil
    }
    
    func fetchStories() -> Story? {
        if let url = Bundle.main.url(forResource: "stories", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let results = try JSONDecoder().decode(Story.self, from: data)
                return results
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        return nil
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error)")
                completion(nil)
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
}
