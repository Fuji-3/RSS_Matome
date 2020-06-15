//
//  NewsTableViewCell.swift
//  RSS_Reader
//
//  Created by Kimisira on 2019/10/20.
//  Copyright © 2019年 Kimisira. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    let titleLabel: UILabel = {
        //frame: CGRect(x: 83, y: 3, width: 232, height: 37
        let label: UILabel = UILabel()
        label.text = ""

        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 15

        label.font.withSize(15)
        //label.backgroundColor = UIColor.blue
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        // label.sizeToFit()
        return label
    }()
    let dateLabel: UILabel = {
        //frame: CGRect(x: 206, y: 40, width: 110, height: 15
        let label: UILabel = UILabel()
        label.text = ""

        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 8

        label.font.withSize(10)
        //label.backgroundColor = UIColor.red
        label.sizeToFit()
        return label
    }()

    var iconImageView: UIImageView = {
        //x: 3, y: 3, width: 70, height: 55)
        let imageView = UIImageView()

        return imageView
    }()

    //nibからロードされた後に呼びだされる
    /*override func awakeFromNib() {
     super.awakeFromNib()
     // Initialization code
     }*/

    //選択状態
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(self.titleLabel)
        contentView.addSubview(self.dateLabel)
        contentView.addSubview(self.iconImageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //ViewをaddSubviewした時、親Viewのframeを変更した時 に呼ばれます。
    override func layoutSubviews() {
        super.layoutSubviews()
        //print("layoutSuviews")
        iconImageView.frame = CGRect(x: 1, y: 1, width: 68, height: 68)

        titleLabel.frame = CGRect(x: (iconImageView.frame.width + 2), y: 1, width: contentView.frame.width - (iconImageView.frame.width) - 4, height: 47)

        dateLabel.frame = CGRect(x: (iconImageView.frame.width + 2), y: titleLabel.frame.height + 2, width: 200, height: 20)

    }
}
