//
//  NewsTableViewModel.swift
//  RSS_Reader
//
//  Created by Kimisira on 2019/08/29.
//  Copyright © 2019年 Kimisira. All rights reserved.
//

import Foundation
import RealmSwift
import SDWebImage

protocol NewsTableViewInputModel {
    func getURLList(title: String, completion:@escaping(Plist<[String: String]>) -> Void)
    func getNews(list: [String: String], completion:@escaping(Plist<[YahooNewsXMLData]>) -> Void)
    //func imageGetHTML(str: String)
}

class NewsTableViewModel {
}

extension NewsTableViewModel: NewsTableViewInputModel {
    //RealmからセレクトされたPlistを持ってくる
    func getURLList(title: String, completion:@escaping(Plist<[String: String]>) -> Void) {
        DispatchQueue.global(qos: .background).sync {
            do {
                let realm = try Realm()
                let object = realm.objects(TitlesObject.self).filter("categori == %@", title).first

                var urlList: [String: String] = [:]
                guard ((object) != nil) else {
                    completion(.failure("CobetNewsGet object init - Error"))
                    return
                }
                for list in (object?.newsList)! {
                    urlList[list.newsTitle] = list.newsTitleURL
                }

                completion(.success(urlList))
            } catch {
                completion(.failure("CobetNewsGet - Error"))
            }
        }
    }

    //Plistから選択されたNewsを持ってくる
    func getNews(list: [String: String], completion:@escaping(Plist<[YahooNewsXMLData]>) -> Void) {
        let url = "https://headlines.yahoo.co.jp/rss"

        DispatchQueue.global(qos: .background).sync {
            for listURL in list {
                let mmm = YahooNewsRSS()
                mmm.xml_get(str: url + listURL.value) { (xmlData) in
                    switch xmlData {
                    case .success(let response):
                        completion(.success(response))
                    case .failure:
                        completion(.failure("Cobetu TV Get News Error"))
                    }
                }
            }
        }
    }

}
