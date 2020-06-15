//
//  TitlesViewController.swift
//  RSS_Matome
//
//  Created by Kimisira on 2019/11/25.
//  Copyright © 2019年 Kimisira. All rights reserved.
//

import UIKit

// NewsList画面
class TitlesViewController: UITableViewController {

    private  var inputPresenter: TitlesPresenterInputDelegate!

    //画面遷移用プロパティ
    var titleStr: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = titleStr
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.allowsMultipleSelection = true

        //Plistを読み込みをtitleで区別
        self.inputPresenter.inputPlist(titleStr: self.titleStr)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.inputPresenter.viewWillDisappear(title: self.titleStr)

    }

}
extension TitlesViewController {
    func presenter(presenter: TitlesPresenterInputDelegate) {
        self.inputPresenter = presenter
    }
}

extension TitlesViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath)
        if let markcell = cell {
            if markcell.accessoryType == .none {
                self.inputPresenter.tableViewCellSelctRow(indexPath: indexPath)
                markcell.accessoryType = .checkmark
            } else {
                self.inputPresenter.tableViewCellSelctRow(indexPath: indexPath)
                markcell.accessoryType = .none
            }

        }
    }

}
extension TitlesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputPresenter.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = self.inputPresenter.titleOutput(row: indexPath.row)

        if self.inputPresenter.selectedCell.contains(self.inputPresenter.titleOutput(row: indexPath.row)) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

}

extension TitlesViewController: TitlesPresenterOutputDelegate {
    func titleListUpdata() {
        self.tableView.reloadData()
    }
}
