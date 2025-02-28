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

//1. セレクトされたxmlのサイトを配列にまとめる
//2. 1を元にxmlのデータを取りに行く
//3. 2をRealmに保存
//4. 3から取得専用

protocol NewsTableViewInputModel {
    func getURLList(title: String, completion:@escaping(Plist<[String: String]>) -> Void)
    func getNews(list: [String: String], completion:@escaping(Plist<[YahooNewsXMLData]>) -> Void)
    func addRealm(title: String, newsListData: [YahooNewsXMLData], completion:@escaping(Plist<String>) -> Void)
    func getRealm(title: String, completion:@escaping(Plist<[YahooNewsXMLData]>) -> Void)
}

class NewsTableViewModel {}
extension NewsTableViewModel: NewsTableViewInputModel {

    func getURLList(title: String, completion:@escaping(Plist<[String: String]>) -> Void) {
        DispatchQueue.global(qos: .background).sync {
            do {
                let realm = try Realm()
                let object = realm.objects(TitlesObject.self).filter("categori == %@", title).first

                var urlList: [String: String] = [:]
                //セレクトされたListが無い場合
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

    func getNews(list: [String: String], completion:@escaping(Plist<[YahooNewsXMLData]>) -> Void) {
        
        //廃止 let url = "https://headlines.yahoo.co.jp/rss"
        let url = "https://news.yahoo.co.jp/rss/media"
        
        var newsList: [YahooNewsXMLData] = []

        let dispatchGroup = DispatchGroup()
        let qu1 = DispatchQueue(label: "getNews--Get")

        for listURL in list {
            dispatchGroup.enter()
            qu1.async(group: dispatchGroup) {
                let mmm = YahooNewsRSS()
                mmm.xml_get(str: url + listURL.value) { (xmlData) in
                    switch xmlData {
                    case .success(let response):
                        newsList += response
                        dispatchGroup.leave()
                    case .failure:
                        completion(.failure("Cobetu TV Get News Error"))
                        dispatchGroup.leave()
                    }
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            print("All getNews ")
            completion(.success(newsList))
        }

    }

    func addRealm(title: String, newsListData: [YahooNewsXMLData], completion: @escaping (Plist<String>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let realm = try Realm()
                let objects = realm.objects(CobetuNewsObject.self).filter("categori == %@", title).first
                //新規 or 追加
                if objects == nil {
                    let cobetuNewsObject = CobetuNewsObject()
                    cobetuNewsObject.categori = title

                    try realm.write {
                        for cells in newsListData {

                            let newsList = CobetuNewsList()

                            newsList.title  = cells.title
                            newsList.pubDate = cells.pubDate
                            newsList.link = cells.link
                            newsList.imgURL = cells.imgURL

                            cobetuNewsObject.newsList.append(newsList)
                        }
                        realm.add(cobetuNewsObject)

                        completion(.success("新規"))
                    }
                } else {
                    print("追加")
                    try realm.write {
                        let newsObjects = objects?.newsList

                        realm.delete(newsObjects!)

                        for cells in newsListData {
                            let newsList = CobetuNewsList()
                            newsList.title  = cells.title
                            newsList.pubDate = cells.pubDate
                            newsList.link = cells.link
                            newsList.imgURL = cells.imgURL

                            objects!.newsList.append(newsList)
                        }
                        completion(.success("追加"))
                    }

                }
            } catch {
                completion(.failure("セレクトしたCellのエラー"))
            }
        }
    }

    func getRealm(title: String, completion: @escaping (Plist<[YahooNewsXMLData]>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let realm = try Realm()
                let object = realm.objects(CobetuNewsObject.self).filter("categori == %@", title).first

                guard ((object) != nil) else {
                    completion(.failure("CobetNewsGet object init - Error"))
                    return
                }
                var listData: [YahooNewsXMLData] = []

                for data in  (object?.newsList)! {
                    var xml =  YahooNewsXMLData()
                    xml.title = data.title
                    xml.link = data.link
                    xml.pubDate = data.pubDate
                    xml.imgURL = data.imgURL
                    listData.append(xml)
                }
                listData.sort(by: { (lhs, rhs) -> Bool in
                    return  rhs.pubDate <  lhs.pubDate
                })
                listData.sorted()

                completion(.success(listData))

            } catch {
                completion(.failure("getRealm Error"))
            }
        }
    }
}
