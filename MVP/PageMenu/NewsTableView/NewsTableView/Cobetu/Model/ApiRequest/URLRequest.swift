//
//  URLRequest.swift
//  RSS_Reader
//
//  Created by Kimisira on 2019/09/02.
//  Copyright © 2019年 Kimisira. All rights reserved.
//

import Foundation
public struct XMLData {
    var title: String!
    var link: String!
    var date: String!
    var subject: String!
    var img: String!
    init() {
    }

}

enum Result<T> {
    case success(T)
    case failure(Error)
}
enum APIError: Error, CustomStringConvertible {
    case invalidURL
    case netWarkError
    var description: String {
        switch self {
        case .invalidURL: return "無効なURL"
        case .netWarkError: return "本体通信に関連するエラー "
        }
    }
}

class UrlRequest: NSObject {
    //XMLのタグ
    fileprivate  var checkElement = ""
    fileprivate var channelTag = ""

    //xmlの構造
    fileprivate var xmlDate: XMLData!
    //XMLのデータ
    fileprivate  var elementArray = [XMLData]()

    //xml -> xml一つのデータ
    fileprivate  var elementDicitonary = [
        "title": "",
        "link": "",
        "dc:date": "",
        "dc:subject": "",
        "content:encoded": ""
    ]

    // func api_get(str:String,success:()->Void,failure:()->Void)
    //xml -> T/F

    func api_get(str: String, completion: @escaping(Result<[XMLData]>) -> Void) {
        let url = URL(string: str)

        let config = URLSessionConfiguration.default //タイムアウト値、キャッシュやクッキーの扱い方、

        let session = URLSession(configuration: config)
        let request = URLRequest(url: url!)

        //非同期通信
        let task = session.dataTask(with: request) { (data, response, error) in
            //インターネット関連するエラー  data nil response nil error String
            guard error  == nil  else {
                DispatchQueue.main.async {
                    completion(.failure(APIError.netWarkError))
                }
                return
            }
            //404
            let response = response as? HTTPURLResponse
            guard response?.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(APIError.invalidURL))
                }
                return
            }
            //パース
            let parser = XMLParser(data: data!)
            parser.delegate = self
            parser.parse()

            DispatchQueue.main.async {

                //Modelのクロージャにいく
                completion(.success(self.elementArray))
            }
            //非同期終了
        }
        task.resume()

    }

}

extension UrlRequest: XMLParserDelegate {
    //解析_要素の開始時
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {

        //XMLのタグ
        checkElement = elementName

        //rdf のいらないところ
        if checkElement == "channel"{
            channelTag = "channel"
        }
    }
    //解析_要素の内の値取得
    func parser(_ parser: XMLParser, foundCharacters string: String) {

        //rdf のいらないところ
        if  channelTag == "channel" && checkElement == "title" && checkElement == "items"{
            channelTag = ""
            checkElement = ""
        } else {
            if string != "\n"{

                if checkElement == "title"{
                    xmlDate = XMLData()
                    xmlDate!.title = string

                }
                if checkElement == "link"{
                    xmlDate!.link  = string
                }
                if checkElement == "dc:date"{
                    xmlDate!.date  = string
                }
                if checkElement == "dc:subject"{
                    xmlDate!.subject = string
                }
                if checkElement == "content:encoded"{

                    /*
                     //imageURLの調整
                     let imageStart = NSString(string: string).range(of: "livedoor.blogimg.jp/").location
                     let imageEnd = NSString(string: string).range(of: "width=").location

                     var imageString = String(string[string.index(string.startIndex, offsetBy: imageStart)..<string.index(string.startIndex, offsetBy: imageEnd)])

                     if  imageString.range(of: "alt=") != nil {
                     let imageStart = NSString(string: imageString).range(of: "https").location
                     let imageAlt = NSString(string: imageString).range(of: "alt=").location
                     imageString = String(imageString[imageString.index(string.startIndex, offsetBy: imageStart)..<imageString.index(string.startIndex, offsetBy: imageAlt)])
                     }
                     xmlDate!.img = imageString
                     */
                    xmlDate.img = string
                    //content が入ったらデータを1単位で配列に追加
                    elementArray.append(xmlDate)

                    xmlDate = nil

                }
            }

        }

    }

    //解析_要素の終了時
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        if checkElement == "title"{
            if  elementDicitonary["title"] != nil {
                // print("sすでにある \(str)")
            } else {
                //print("title 複数")
            }
            //element_Array.append([element_Dicitonary])

            checkElement = ""
        }
        if checkElement == "content:encoded"{
            elementDicitonary.removeAll()
            checkElement = ""
        }
    }

}
