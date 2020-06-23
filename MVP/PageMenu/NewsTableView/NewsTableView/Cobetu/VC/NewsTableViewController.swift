//
//  NewsTableViewController.swift
//  RSS_Reader
//
//  Created by Kimisira on 2019/08/28.
//  Copyright © 2019年 Kimisira. All rights reserved.
//

import UIKit
import PKHUD
import SDWebImage

class NewsTableViewController: UIViewController {

    private var tableView: UITableView!
    private var data = [YahooNewsXMLData]()

    private var model = NewsTableViewModel()
    private  var inputPresenter: NewsTableViewPresenterInputDelegate!
    func presenter(presenter: NewsTableViewPresenterInputDelegate) {
        self.inputPresenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)

        self.tableViewConfig()
        self.refreshConfig()

    }
    override func viewWillAppear(_ animated: Bool) {
        self.inputPresenter.getNewsRealm(title: title!)
    }

}
extension NewsTableViewController {
    func tableViewConfig() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsTableViewCell")
        self.view.addSubview(tableView)
    }
}
//Refresh系
extension NewsTableViewController {
    func refreshConfig() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable(sender:)), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    @objc func refreshTable(sender: UIRefreshControl) {

        self.inputPresenter.getURL(title: self.title!)

    }
}

//TableViewDelegate
extension NewsTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        //NewsサイトをwebViewを開く
        let kiji = KijiViewController(newsURL: self.inputPresenter.newsLists[indexPath.row].link)
        self.navigationController?.pushViewController(kiji, animated: true)

    }

}
extension NewsTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.inputPresenter.newsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell") as? NewsTableViewCell
        guard self.inputPresenter.newsLists.count > 0  else {
            return cell!
        }

        cell?.titleLabel.text =   self.inputPresenter.newsLists[indexPath.row].title
        cell?.dateLabel.text =   self.inputPresenter.newsLists[indexPath.row].pubDate

        //imageを取りに行く
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: self.inputPresenter.newsLists[indexPath.row].imgURL)
            SDWebImageManager.shared.loadImage(with: url, options: .progressiveLoad, progress: nil) { (image, _, _, _, _, _) in
                DispatchQueue.main.async {
                    cell?.iconImageView.image = image
                }
            }
        }

        return cell!
    }

}

extension NewsTableViewController: NewsTableViewPresenterOutputDelegate {
    func stopRefresh() {
        self.tableView.refreshControl?.endRefreshing()
        self.tableView.reloadData()
    }

    func titleListUpdata() {
        self.tableView.reloadData()

    }

}
