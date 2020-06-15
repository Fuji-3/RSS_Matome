//
//  Alamofire.swift
//  RSS_Reader
//
//  Created by Kimisira on 2019/09/03.
//  Copyright © 2019年 Kimisira. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SWXMLHash

struct XMLFaile: Codable {
    var title: String
    var link: String
    var date: String
    var subject: String
    var img: String
}

class AlamofireClass: NSObject {
    private var checkelement = ""

    //let afImageCache = AlamofireImage()
    var imageString: String = ""

    func getURL( str: String) {
        let url = URL(string: str)

        //非同期　開始
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseData { (response) in

                if let error  = response.error {
                    print("URL エラー \(error.localizedDescription)")

                } else {

                    let xml = SWXMLHash.config({ (config) in
                        config.shouldProcessLazily = true
                    }).parse(response.data!)

                    let rdf = xml["rdf:RDF"]["item"]

                    //xml展開
                    for item in rdf.all {
                        //print("title \(item["title"].element!.text)")

                        let  str = item["content:encoded"].element!.text

                        var  imageStart = NSString(string: str).range(of: "livedoor.blogimg.jp/").location

                        //urlの画像拡張子で切る
                        var imageEnd = NSString(string: str).range(of: "width=").location - 2

                        self.imageString = String(str[str.index(str.startIndex, offsetBy: imageStart)..<str.index(str.startIndex, offsetBy: imageEnd)])

                        if  self.imageString.range(of: "alt=") != nil {
                            imageStart = NSString(string: self.imageString).range(of: "https").location
                            imageEnd = (NSString(string: self.imageString).range(of: "alt=").location) - 2
                            self.imageString = String(self.imageString[self.imageString.index(str.startIndex, offsetBy: imageStart)..<self.imageString.index(str.startIndex, offsetBy: imageEnd)])
                        }

                        let xmlFile: XMLFaile = XMLFaile(
                            title: item["title"].description,
                            link: item["link"].description,
                            date: item["dc:date"].description,
                            subject: item["dc:subject"].description,
                            img: self.imageString)

                        print(xmlFile)
                        //self.afImageCache.imageCache_Add(imageString: self.imageString)
                        //let image = self.alamofire_image_cache.imageCache_Fetch(imageString: self.imageString)
                        // print("Alamofire image \(image)")
                        // let cachedImage = self.alamofire_image_cache.imageCache_Fetch(imageString: self.imageString)

                    }
                }
                //非同期　終わり

        }
    }

    func getFeche() {
        // let a = alamofire_image_cache.imageCache_Fetch(imageString: imageString)
        // print("a \(a)")
    }

}
