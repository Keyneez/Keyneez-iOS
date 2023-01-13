//
//  UIImageView+Extension.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/14.
//

import UIKit
import Kingfisher
import FirebaseStorage

extension UIImageView {
  func setImage(with UrlString: String) {
    let cache = ImageCache.default
    guard let newUrlString = UrlString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {return}
    let imageUrl  = "\(StorageService.shared.imageBaseUrl)\(newUrlString)"
    print("캐싱한것 찾을떄 쓰이는 url \(imageUrl)")
    cache.retrieveImage(forKey: imageUrl) { (result) in
      switch result {
      case .success(let value):
        if let image = value.image {
          print("캐시가 된것을 꺼내쓴다.")
          self.image = image
        } else {
          let storage = Storage.storage()
          storage.reference(forURL: imageUrl).downloadURL { (url, error) in
            if let error = error {
              print("ERROR \(error.localizedDescription)")
              return
            }
            guard let url = url else {
              return
            }
            print("이미지 캐시가 되지 않아서 다시 다운받는다.", url)
            let resource = ImageResource(downloadURL: url, cacheKey: imageUrl)
            self.kf.setImage(with: resource)
          }
        }
      case .failure(let error):
        print("error \(error.localizedDescription)")
      }
    }
  }
}
