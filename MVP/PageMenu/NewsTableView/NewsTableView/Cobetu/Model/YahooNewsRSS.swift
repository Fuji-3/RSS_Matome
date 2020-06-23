//
//  YahooNewsRSS.swift
//  RSS_Matome
//
//  Created by Kimisira on 2019/11/21.
//  Copyright © 2019年 Kimisira. All rights reserved.
//
import Foundation
import HTMLReader

struct YahooNewsXMLData: Codable {
    var title: String!
    var link: String!
    var pubDate: String!
    var imgURL: String!
    init() {}
    
}
extension YahooNewsXMLData: Comparable {
    //日付け順
    static func < (lhs: YahooNewsXMLData, rhs: YahooNewsXMLData) -> Bool {
        return  rhs.pubDate <  lhs.pubDate
    }
    
}

class YahooNewsRSS: NSObject {
    //XMLのタグ
    fileprivate  var checkElement = ""
    fileprivate var channelTag = ""
    
    //xmlの構造
    fileprivate var xmlData: YahooNewsXMLData!
    //XMLのデータ
    fileprivate var elementArray = [YahooNewsXMLData]()
    //xml -> xml一つのデータ
    fileprivate  var elementDicitonary = [
        "title": "",
        "link": "",
        "pubDate": "",
        "imgURL": ""
    ]
    
    fileprivate  var items = ""
    
    //XML解析
    func xml_get(str: String, completion: @escaping(Result<[YahooNewsXMLData]>) -> Void) {
        let url = URL(string: str)
        
        let config = URLSessionConfiguration.default //タイムアウト値、キャッシュやクッキーの扱い方、
        
        let session = URLSession(configuration: config)
        
        let request = URLRequest(url: url!)
        
        //非同期通信
        let task = session.dataTask(with: request) { (data, response, error) in
            //インターネット関連するエラー  data nil response nil error String
            guard error  == nil  else {
                completion(.failure(APIError.netWarkError))
                
                return
            }
            //404
            let response = response as? HTTPURLResponse
            guard response?.statusCode == 200 else {
                
                completion(.failure(APIError.invalidURL))
                
                return
            }
            //パース
            let parser = XMLParser(data: data!)
            parser.delegate = self
            
            parser.parse()
            
            DispatchQueue.global(qos: .background).async {
                //Modelのクロージャにいく
                completion(.success(self.elementArray) )
            }
            //非同期終了
        }
        task.resume()
        
    }
    
}

extension YahooNewsRSS: XMLParserDelegate {
    //解析_要素の開始時
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        if elementName == "item" {
            items = "item"
            return
        }
        
        if items == "item" && elementName == "title"{
            checkElement = "title"
            xmlData = YahooNewsXMLData()
            return
        }
        if items == "item" && elementName == "link"{
            checkElement = "link"
            return
        }
        if items == "item" && elementName == "pubDate"{
            checkElement = "pubDate"
            return
        }
        
    }
    //解析_要素の内の値取得
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if checkElement == "title" {
            
            //string が２行だかどうか
            if xmlData.title == nil {
                xmlData.title = string
            } else {
                xmlData.title = (xmlData.title + string)
            }
            
            return
        }
        if checkElement == "link" {
            xmlData.link = string
            let url = URL(string: xmlData.link)
            do {
                let sourceHTML =  try String(contentsOf: url!, encoding: String.Encoding.utf8)
                
                let html = HTMLDocument(string: sourceHTML)
                
                let htmlElement = html.firstNode(matchingSelector: "meta[property^=\"og:image\"]")
                guard let content = htmlElement?.attributes["content"] else {
                    //error
                    return
                }
                
                xmlData.imgURL = content
            } catch {
                print("image Get Eoor")
            }
            return
        }
        if checkElement == "pubDate" {
            //String-> Date
            let dateFormat = DateFormatter()
            dateFormat.locale = Locale(identifier: "en_US_POSIX")
            
            dateFormat.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
            dateFormat.timeZone = TimeZone(secondsFromGMT: 0)
            let date = dateFormat.date(from: string)
            
            //Date -> String
            let jpf = DateFormatter()
            jpf.locale = Locale(identifier: "ja_JP")
            jpf.dateFormat = "yyyy/MM/dd HH:mm"
            let dateStrig = jpf.string(from: date!)
            
            xmlData.pubDate = dateStrig
            elementArray.append(xmlData)
            xmlData = nil
            return
        }
        
    }
    
    //解析_要素の終了時
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if items == "item" && checkElement == "title"{
            checkElement = ""
            return
        }
        if items == "item" && checkElement == "link"{
            checkElement = ""
            return
        }
        if items == "item" && checkElement == "pubDate"{
            checkElement = ""
            items = ""
            return
        }
        
    }
    
}
