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
    func stopRefresh()
}

//view->model
protocol NewsTableViewPresenterInputDelegate {
    //ニュースリストを取りに行く
    //そこからニュースを取りに行く and  画像取りに行く
    var newsLists: [YahooNewsXMLData] {get}
    var newsCount: Int {get}
    func getURL(title: String)
    func getNewsRealm(title: String)
    
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
        print("newsCount", newsList.count)
        return newsList.count
    }
    var newsLists: [YahooNewsXMLData] {
        return newsList
    }
    
    //サイトに選択されたリストを元にデータを取りに行く
    func getURL(title: String) {
        print("getURL -1")
        let dispatchGroup = DispatchGroup()
        let qu1 = DispatchQueue(label: "getURL-GroupQueue")
        print("getURL -2")
        HUD.show(.progress)
        dispatchGroup.enter()
        qu1.async(group: dispatchGroup) {
            self.model.getURLList(title: title) { (newsLists) in
                switch newsLists {
                case .success(let list):
                    self.selectedURL = list
                    dispatchGroup.leave()
                case .failure(let error):
                    print("getURL Get error:", error)
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.enter()
        qu1.async(group: dispatchGroup) {
            self.newsList = []
            self.model.getNews(list: self.selectedURL, completion: { (newsData) in
                switch newsData {
                case .success(let list):
                    self.newsList = list.sorted()
                    DispatchQueue.global(qos: .background).async {
                        self.model.addRealm(title: title, newsListData: self.newsList, completion: { (list) in
                            switch list {
                            case.success(let str):
                                dispatchGroup.leave()
                            case .failure(let error):
                                print("addRealm Get error", error)
                                dispatchGroup.leave()
                            }
                        })
                    }
                    
                case .failure(let error):
                    print("getNews Get error:", error)
                    dispatchGroup.leave()
                }
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            HUD.flash(.labeledSuccess(title: "読み込み成功", subtitle: ""), delay: 2)
            self.view.stopRefresh()
            
        }
        self.newsList = []
    }
    
    //Realmからxmlのデーターを持ってくる
    func getNewsRealm(title: String) {
        HUD.show(.progress)
        DispatchQueue.global(qos: .userInitiated).async {
            self.model.getRealm(title: title) { (list) in
                switch list {
                case .success(let str):
                    self.newsList = str.sorted()
                    
                    DispatchQueue.main.async {
                        HUD.flash(.labeledSuccess(title: "DB読み取り成功", subtitle: ""), delay: 1)
                        self.view.titleListUpdata()
                    }
                case .failure(let error):
                    print("getRealm Get error", error)
                    DispatchQueue.main.async {
                        HUD.flash(.labeledError(title: "DB読み取りエラー", subtitle: ""))
                    }
                }
            }
        }
        
    }
    
}

//getURLの分岐
extension NewsTableViewPrsenter {
    //xmlData Get
    func fastGetNews(title: String) {
        self.newsList = []
        self.model.getNews(list: self.selectedURL, completion: { (newsData) in
            switch newsData {
            case .success(let list):
                self.newsList = list
                
            case .failure(let error):
                DispatchQueue.main.async {
                    HUD.flash(.error, delay: 1)
                }
                
            }
        })
    }
}
