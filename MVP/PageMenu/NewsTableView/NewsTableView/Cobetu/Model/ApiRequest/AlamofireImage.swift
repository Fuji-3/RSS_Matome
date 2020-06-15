//
//  AlamofireImage.swift
//  RSS_Reader
//
//  Created by Kimisira on 2019/09/13.
//  Copyright © 2019年 Kimisira. All rights reserved.
//

import Foundation
import AlamofireImage
import Alamofire
import SDWebImage

enum RRRResult<Success> {
    case success(Success)

}
struct AlamofireImage {

    fileprivate let cache = URLCache(
        memoryCapacity: 20*1024*1024,
        diskCapacity: 150*1024*1024,
        diskPath: "com.alamofire.imagedownloader")

    fileprivate let imageCache = AutoPurgingImageCache(
        //フィルター済みの画像もキャッシュされる
        memoryCapacity: 100 * 1024 * 1024,  // 100 MB
        //memoryCapacityを超えた時にキャッシュの画像を削除した後のキャッシュサイズの上限
        preferredMemoryUsageAfterPurge: 60 * 1024 * 1024 // 60 MB
    )

    fileprivate let downloader = ImageDownloader()
    fileprivate let filter = AspectScaledToFillSizeCircleFilter(size: CGSize(width: 100, height: 50))

    func imageCache_Add(imageString: String, completion:@escaping(RRRResult<UIImage>) -> Void) {

        /*
         let urlRequest = URLRequest(url: URL(string: imageString)!)

         downloader.download(urlRequest) { (response) in

         //image DL
         Alamofire.request(imageString).responseImage(completionHandler: { (_) in

         print("alamofire_responseData \(response.data!)")
         let image = UIImage(data: response.data!, scale: 1.0)

         // let imageCache = AutoPurgingImageCache()
         print("alamofire_iamge  \(String(describing: image))")
         //Add
         self.imageCache.add(image!, withIdentifier: "avatar")
         let cachedImage = self.imageCache.image(withIdentifier: "avatar")
         print("cachedimage \(String(describing: cachedImage))")
         completion(.success())
         })

         }

         let urlRequest = URLRequest(url: URL(string: imageString)!)
         downloader.download(urlRequest) { (response) in
         if let image = response.result.value {
         print("image \(image)")
         }
         }*/

    }

    /*func imageCache_Fetch(imageString:String)->(UIImage?){
     let cachedImage = self.imageCache.image(withIdentifier: "avater")
     print("ddd \(cachedImage)")
     eturn cachedImage
     }*/

    /*func imageCache_Remove(imageString:String){
     self.imageCache.removeImage(withIdentifier: imageString)
     }*/

}
