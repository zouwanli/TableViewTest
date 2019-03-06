//
//  ZwlClickInfoCell.swift
//  TableViewTest
//
//  Created by Zouwanli on 2019/3/5.
//  Copyright © 2019 Zouwanli. All rights reserved.
//

import UIKit

class ZwlClickInfoCell: UITableViewCell {

    let targetLab = UILabel()
    let urlLab = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func zwlClickInfoCellWithTableView(tableView:UITableView) ->ZwlClickInfoCell{
        let identifier = "iZwlClickInfoCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ZwlClickInfoCell
        if cell == nil {
            cell = ZwlClickInfoCell.init(style: .default, reuseIdentifier: identifier)
            tableView.register(ZwlClickInfoCell.classForCoder(), forCellReuseIdentifier: identifier)
        }
        return cell!
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.zwlClickInfoCellSetUpUI()
    }
    
    private func zwlClickInfoCellSetUpUI(){
        self.backgroundColor = .clear
//        self.selectionStyle = .none
        
        /*
         * 代码添加背景图片约束
         */
        let bgImage = UIImageView()
        bgImage.backgroundColor = .white
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bgImage)
        let bgImageH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[bgImage]-5-|", options: .alignmentMask, metrics: nil, views: ["bgImage":bgImage])
        contentView.addConstraints(bgImageH)
        let bgImageV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[bgImage]-0.5-|", options: .alignmentMask, metrics: nil, views: ["bgImage":bgImage])
        contentView.addConstraints(bgImageV)

        targetLab.frame = CGRect(x: 10, y: 5, width: SCREEN_WIDTH-20, height: 20)
        targetLab.font = UIFont.systemFont(ofSize: 14)
        targetLab.textColor = ZwlRGBA(51, 51, 51, 1)
        self.contentView.addSubview(targetLab)
        
        urlLab.frame = CGRect(x: 10, y: 25, width: SCREEN_WIDTH-20, height: 20)
        urlLab.font = UIFont.systemFont(ofSize: 13)
        urlLab.textColor = ZwlRGBA(92, 92, 92, 1)
        self.contentView.addSubview(urlLab)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
