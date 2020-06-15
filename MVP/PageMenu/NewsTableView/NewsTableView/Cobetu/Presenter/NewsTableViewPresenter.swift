//
//  NewsTableViewPresenter.swift
//  RSS_Reader
//
//  Created by Kimisira on 2019/08/29.
//  Copyright © 2019年 Kimisira. All rights reserved.
//

import Foundation
import PKHUD

//model->View
protocol NewsTableViewPresenterOutputDelegate {
    func titleListUpdata()
}

//view->model
protocol NewsTableViewPresenterInputDelegate {
    //ニュースリストを取りに行く
    //そこからニュースを取りに行く and  画像取りに行く
    var newsLists: [YahooNewsXMLData] {get}
    var newsCount: Int {get}
    func getURL(title: String)

}

class NewsTableViewPrsenter {
    //セレクトされたリストのデータ
    private var selectedURL: [String: String] = [:]
    //TableViewに表示する ニュース欄
    private var newsList: [YahooNewsXMLData] = []

    var view: NewsTableViewPresenterOutputDelegate!
    var model: NewsTableViewInputModel!

    init(view: NewsTableViewPresenterOutputDelegate, model: NewsTableViewInputModel) {
        self.view = view
        self.model = model
    }
}

extension NewsTableViewPrsenter: NewsTableViewPresenterInputDelegate {
    var newsCount: Int {
        return newsList.count
    }
    var newsLists: [YahooNewsXMLData] {

        return newsList
    }

    //サイトに選択されたリストを元にデータを取りに行く
    //ここが挙動がおかしい
    func getURL(title: String) {
        HUD.show(.progress)
        self.newsList = []

        DispatchQueue.global(qos: .background).async {
            self.model.getURLList(title: title) { (newsLists) in
                switch newsLists {
                case .success(let list):
                    self.selectedURL = list

                    //選択されたリストがある時にサイトに取りに行く
                    guard self.selectedURL.isEmpty else {
                        self.model.getNews(list: self.selectedURL, completion: { (newsData) in
                            switch newsData {
                            case .success(let list):
                                self.newsList += list
                                self.newsList.sort()

                                DispatchQueue.main.async {
                                    HUD.flash(.labeledSuccess(title: "読み込み完了", subtitle: ""), delay: 1)
                                    self.view.titleListUpdata()
                                }
                            case .failure(let error):
                                print("NewsList - GetError", error)
                                DispatchQueue.main.async {
                                    HUD.flash(.error, delay: 1)
                                }

                            }
                        })
                        return
                    }
                case .failure(let error):
                    print("GetURL- GetError", error)
                    DispatchQueue.main.async {
                        HUD.flash(.error, delay: 1)
                    }

                }
            }
        }

    }
}
