//
//  TitlesPresenter.swift
//  RSS_Matome
//
//  Created by Kimisira on 2019/12/29.
//  Copyright © 2019年 Kimisira. All rights reserved.
//

import Foundation
import PKHUD

protocol TitlesPresenterInputDelegate {
    //画面を表示　key配列
    var count: Int {get}
    var titles: [String] {get}
    var selectedCell: [String] {get}

    func titleOutput(row: Int) -> String

    //CellのPlistファイル
    func inputPlist(titleStr: String)
    //Cell タップ
    func tableViewCellSelctRow(indexPath: IndexPath)

    //viewが表示されなくなる直前
    func viewWillDisappear(title: String)
}
protocol TitlesPresenterOutputDelegate {
    func titleListUpdata()
}

class TitlesPresenter {
    var view: TitlesPresenterOutputDelegate!
    var model: TitlesInputModel!

    init(view: TitlesPresenterOutputDelegate, model: TitlesInputModel) {
        self.view = view
        self.model = model
    }

    //Plistファイルのデータ
    private var plist: [String: String] = [:]

    //plistからタイトルをだけを出力
    internal  var titles: [String] = []

    //チェックされたセルの位置を保存しておく
    //private var selectedCells: [String: String] =  [:]

    //Plist からの出力
    private var inputedCells: [String] = []

}

extension TitlesPresenter: TitlesPresenterInputDelegate {

    var selectedCell: [String] {
        return inputedCells
    }

    var title: [String] {
        return titles
    }

    func titleOutput(row: Int) -> String {
        return titles[row]
    }

    var count: Int {
        return plist.count
    }
    //titleで区別し、plistとセレクトリストを取りに行く
    func inputPlist(titleStr: String) {
        switch titleStr {
        case "国内":
            self.titleStrTred(urlList: "Kokunai_Property List", titleStr: titleStr)
        case "国際":
            self.titleStrTred(urlList: "Kokusai_Property List", titleStr: titleStr)
        case "経済":
            self.titleStrTred(urlList: "Keizai_Property List", titleStr: titleStr)
        case "エンタメ":
            self.titleStrTred(urlList: "Entame_Property List", titleStr: titleStr)
        case "スポーツ":
            self.titleStrTred(urlList: "Supo-tu_Property List", titleStr: titleStr)
        case "IT":
            self.titleStrTred(urlList: "IT_Property List", titleStr: titleStr)
        default:
            break
        }
    }

    //plistとセレクトリストを取りに行く -> tablewViewをロードする/エラー
    func titleStrTred(urlList: String, titleStr: String) {
        HUD.show(.progress)
        let dispathGroup = DispatchGroup()
        let qu2 = DispatchQueue(label: "inputPlist.Queue", attributes: .concurrent)

        //Plistファイルを読み取り
        dispathGroup.enter()
        qu2.async(group: dispathGroup) {
            self.model.inputPlist(url: urlList) { (plist) in
                switch plist {
                case .success(let list):
                    self.plist = list

                    for title in self.plist.keys {
                        self.titles.append(title)
                    }
                    self.titles.sort()

                    dispathGroup.leave()
                case .failure(let errorStr):
                    print("Plist読み込みエラー", errorStr)
                    dispathGroup.leave()
                }
            }
        }
        //セルの選択の取得
        dispathGroup.enter()
        qu2.async(group: dispathGroup) {
            // moto plistGet
            self.model.selectedCellGet(title: titleStr, completion: { (plist) in
                switch plist {
                case .success(let list):
                    self.inputedCells = list

                    dispathGroup.leave()
                case .failure:
                    print("セルの選択リストの読み込みエラー")
                    dispathGroup.leave()
                }
            })
            dispathGroup.notify(queue: qu2) {
                DispatchQueue.main.sync {
                    HUD.flash(.labeledSuccess(title: "読み込み完了", subtitle: ""), delay: 1.5)
                    self.view.titleListUpdata()
                }

            }
        }
    }

    //Cell選択時
    func tableViewCellSelctRow(indexPath: IndexPath) {
        let row = titles[indexPath.row]

        if self.inputedCells.contains(row) {
            //Delert
            self.inputedCells.remove(value: row)
        } else {
            //Add
            self.inputedCells.append(row)
        }
    }

    //画面遷移させた時
    func viewWillDisappear(title: String) {
        HUD.show(.progress)
        var selectedCells: [String: String] = [:]

        //セレクトされたCellの配列とplistのDataを照合し url を持ってくる
        for key in self.inputedCells {
            if let value = self.plist[key] {

                selectedCells[key] = value
            }
        }

        //照合したDataを追加しにいく
        self.model.selectedCellAdd(titleStr: title, selectedCell: selectedCells) { (plist) in
            switch plist {
            case .success(let str):
                DispatchQueue.main.async {
                    HUD.flash(.labeledSuccess(title: str, subtitle: ""), delay: 1.5)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    HUD.flash(.labeledError(title: error, subtitle: ""), delay: 1.5)
                }
            }
        }

    }

}
