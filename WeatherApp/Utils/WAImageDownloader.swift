//
//  ImageDownloader.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import UIKit

class WAImageDownloader {
    
    private var cache: NSCache<NSNumber, UIImage>
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    static let shared: WAImageDownloader = WAImageDownloader()
    
    /// Initialize the class with
    /// - Parameters:
    /// cache: Cache limit to store number of items
    /// countLimit : Cached image ID
    /// totalCostLimit: cache size

    private init(cache: NSCache<NSNumber, UIImage> = NSCache<NSNumber, UIImage>(), countLimit: Int = 20, totalCostLimit: Int = 50 * 1024 * 1024) {
        self.cache = cache
        // cache limit set to 20 images
        cache.countLimit = countLimit
        // cache limit set to 50 MB
        cache.totalCostLimit = totalCostLimit
    }
    /// Load the image from cahce and if not available in cache, download from server and save to cache
    /// - Parameters:
    /// imageURL: The URL for image to download
    /// imageNumber : Cached image ID
    ///
    /// - Returns:
    /// The image from cache or server

    func getImage(for imageURL: String, imageNumber: NSNumber, completion: @escaping (UIImage?) -> ()) {
        if let cachedImage = cache.object(forKey: imageNumber) {
            #if DEBUG
            print("Using a cached image for item: \(imageNumber)")
            #endif
            completion(cachedImage)
        } else {
            utilityQueue.async { [weak self] in
                guard let self = self, let url = URL(string: imageURL), let data = try? Data(contentsOf: url), let image = UIImage(data: data) else { return }
                self.cache.setObject(image, forKey: imageNumber)
                completion(image)
            }
        }
    }
}
