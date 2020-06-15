//
//  TagListViewViewController.swift
//  RSS_Reader
//
//  Created by Kimisira on 2019/09/26.
//  Copyright © 2019年 Kimisira. All rights reserved.
//
/*
 import UIKit
 import TagListView

 class TagListViewController: UIViewController {

 let tagListView = TagListView()
 let textField = UITextField()

 let margin: CGFloat = 16.0

 override func viewDidLoad() {
 super.viewDidLoad()
 self.setView()

 }

 func setView() {
 self.navigationController?.navigationBar.isTranslucent = true

 view.addSubview(tagListView)
 view.addSubview(textField)

 tagListView.frame = CGRect(x: margin, y: 70.0, width: view.frame.width - margin*2, height: 0)

 // タグの削除ボタンを有効に
 tagListView.enableRemoveButton = true

 // 今回は削除ボタン押された時の処理を行う
 tagListView.delegate = self

 // タグの見た目を設定
 tagListView.alignment = .left
 tagListView.cornerRadius = 3

 tagListView.textColor = UIColor.black
 tagListView.borderColor = UIColor.lightGray
 tagListView.borderWidth = 1
 tagListView.paddingX = 10
 tagListView.paddingY = 5
 tagListView.textFont = UIFont.systemFont(ofSize: 16)
 tagListView.tagBackgroundColor = UIColor.white

 // タグ削除ボタンの見た目を設定
 tagListView.removeButtonIconSize = 10
 tagListView.removeIconLineColor = UIColor.black

 // テキストフィールドは適当にセット
 textField.delegate = self
 textField.placeholder = "タグを入力してください"
 textField.returnKeyType = UIReturnKeyType.done

 // レイアウト調整
 updateLayout()
 }
 func updateLayout() {
 // タグ全体の高さを取得
 tagListView.frame.size = tagListView.intrinsicContentSize

 //CGFloat CGRect
 textField.frame = CGRect(x: margin, y: tagListView.frame.origin.y + tagListView.frame.height + 5, width: view.frame.width - margin*2, height: CGFloat(40) )
 }

 }
 extension TagListViewController: TagListViewDelegate {
 func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
 print("Tag pressed: \(title), \(sender)")
 tagView.isSelected = !tagView.isSelected
 }
 // タグ削除ボタンが押された
 func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
 print("Tag Remove pressed: \(title), \(sender)")
 sender.removeTagView(tagView)
 // リストからタグ削除
 sender.removeTagView(tagView)
 updateLayout()
 }

 }

 extension TagListViewController: UITextFieldDelegate {
 // テキストフィールドの完了ボタンが押されたら
 func textFieldShouldReturn(_ textField: UITextField) -> Bool {
 if 0 < textField.text!.count {
 // タグを追加
 tagListView.addTag(textField.text!)

 // テキストフィールドをクリアしてレイアウト調整
 textField.text = nil
 updateLayout()

 }
 return true
 }

 }
 */
