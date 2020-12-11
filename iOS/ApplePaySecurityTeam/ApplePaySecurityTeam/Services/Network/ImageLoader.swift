//
//  ImageLoader.swift
//  ApplePaySecurityTeam
//
//  Created by Ravi Vooda on 12/10/20.
//  Copyright © 2020 Ravi Vooda. All rights reserved.
//

import UIKit

protocol ImageLoaderService {
    func load(_ url: URL, for imageView:UIImageView, completion: @escaping ((UIImage?, Error?) -> Void))
    func cancel(for imageView:UIImageView)
}

var globalImageLoaderService:ImageLoaderService = ImageLoaderServiceImpl()

private class ImageLoaderServiceImpl: ImageLoaderService {
    private var prevtaskMapper = [UIImageView: URLSessionDataTask]()
    func cancel(for imageView: UIImageView) {
        if let prev = prevtaskMapper[imageView] {
            prev.cancel()
        }
    }
    
    func load(_ url: URL, for imageView:UIImageView, completion: @escaping ((UIImage?, Error?) -> Void)) {
        cancel(for: imageView)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let _ = self.prevtaskMapper[imageView] else {
                    // Task is cancelled ignore
                    return
                }
                
                guard error == nil else {
                    completion(nil, error)
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    completion(image, nil)
                }
            }
        }
        prevtaskMapper[imageView] = task
        task.resume()
    }
    
    
}
