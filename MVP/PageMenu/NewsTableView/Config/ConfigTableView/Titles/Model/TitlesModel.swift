//
//  TitlesModel.swift
//  RSS_Matome
//
//  Created by Kimisira on 2019/12/29.
//  Copyright © 2019年 Kimisira. All rights reserved.
//

import Foundation
import RealmSwift

enum Plist<T> {
    case success(T)
    case failure(String)
}
protocol TitlesInputModel {

    func inputPlist(url: String, completion:@escaping(Plist<[String: String]>) -> Void)

    func selectedCellAdd(titleStr: String, selectedCell: [String: String], completion:@escaping(Plist<String>) -> Void)
    func selectedCellGet(title: String, completion:@escaping(Plist<[String]>) -> Void)
}

class TitlesModel {}

extension TitlesModel: TitlesInputModel {
    //plistを読み込む
    func inputPlist(url: String, completion: @escaping (Plist<[String: String]>) -> Void) {

        DispatchQueue.global(qos: .background).async {
            guard let plistURL = Bundle.main.path(forResource: url, ofType: ".plist")  else {
                completion(.failure("input plist Error"))
                return
            }

            let  plist = (NSDictionary(contentsOfFile: plistURL) as? [String: String])!
            plist.keys.sorted()
            completion(.success(plist))
        }
    }

    //セレクトしたCellの辞書 追加/更新
    func selectedCellAdd(titleStr: String, selectedCell: [String: String], completion: @escaping (Plist<String>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            //データ追加
            do {
                let realm = try Realm()
                let objects = realm.objects(TitlesObject.self).filter("categori == %@", titleStr).first

                //新規 or 追加
                if objects == nil {

                    let titleObject = TitlesObject()
                    titleObject.categori = titleStr

                    try realm.write {
                        for cells in selectedCell {
                            let newsList = NewsList()

                            newsList.newsTitle = cells.key
                            newsList.newsTitleURL = cells.value
                            titleObject.newsList.append(newsList)

                        }
                        realm.add(titleObject, update: .all)
                        completion(.success("新規"))
                    }
                } else {

                    try realm.write {
                        let newsList = objects?.newsList
                        realm.delete(newsList!)

                        for cells in selectedCell {
                            let newsList = NewsList()
                            newsList.newsTitle = cells.key
                            newsList.newsTitleURL = cells.value

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

    //セレクトしたCell 取得
    func selectedCellGet(title: String, completion: @escaping (Plist<[String]>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let realm = try Realm()
                let plist = realm.objects(TitlesObject.self).filter("categori == %@", title).first

                /*
                 var keys: [String: String] = [:]
                 for selectedCell in (plist?.newsList)! {
                 keys[selectedCell.newsTitleURL] = selectedCell.newsTitle
                 }
                 */
                guard (plist != nil) else {
                    completion(.failure("plist Get-init Error"))
                    return
                }
                var array: [String] = []
                for key in (plist?.newsList)! {
                    array.append(key.newsTitle)
                }

                completion(.success(array))
            } catch {
                completion(.failure("plist Get Error"))
            }
        }

    }

}
