//
//  ImageDownloader.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import UIKit

class ImageDownloader {
    
    private var cache: NSCache<NSNumber, UIImage>
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    static let shared: ImageDownloader = ImageDownloader()
    private init(cache: NSCache<NSNumber, UIImage> = NSCache<NSNumber, UIImage>()) {
        self.cache = cache
        cache.countLimit = 20
        cache.totalCostLimit = 50 * 1024
    }
    
    func getImage(for imageURL: String, imageNumber: NSNumber, completion: @escaping (UIImage?) -> ()) {
        if let cachedImage = cache.object(forKey: imageNumber) {
            #if DEBUG
            print("Using a cached image for item: \(imageNumber)")
            #endif
            completion(cachedImage)
        } else {
            utilityQueue.async {
                guard let url = URL(string: imageURL), let data = try? Data(contentsOf: url), let image = UIImage(data: data) else { return }
                self.cache.setObject(image, forKey: imageNumber)
                completion(image)
            }
        }
    }
    
    private func loadImage(imageURL: String, completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async {
            guard let url = URL(string: imageURL), let data = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
