//
//  ZwlTestHeaderFooterView.swift
//  TableViewTest
//
//  Created by Zouwanli on 2019/3/5.
//  Copyright © 2019 Zouwanli. All rights reserved.
//

import UIKit

class ZwlTestHeaderFooterView: UITableViewHeaderFooterView {
    
    let titleLab = UILabel()
    let contextLab = UILabel()
    let img = UIImageView()
    private let imgIndicator = UIActivityIndicatorView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.zwlTestHeaderFooterViewSetUpUI()
    }
    
    private func zwlTestHeaderFooterViewSetUpUI(){
        
        /*
         * 添加title 标签
         */
        titleLab.frame = CGRect(x: 10, y: 10, width: SCREEN_WIDTH-20, height: 20)
        titleLab.textAlignment = .left
        self.addSubview(titleLab)
        
        /*
         * 添加图片控件
         */
        img.backgroundColor = ZwlRGBA(192, 192, 192, 1)
        self.addSubview(img)
        
        /*
         * 添加内容标签，并添加代码约束
         */
        contextLab.numberOfLines = 0
        contextLab.textAlignment = .left
        self.addSubview(contextLab)
        contextLab.font = UIFont.systemFont(ofSize: 14)
        contextLab.textColor = ZwlRGBA(92, 92, 92, 1)
        contextLab.translatesAutoresizingMaskIntoConstraints = false
        
        let conLabH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[_contextLab]-10-|", options: .alignmentMask, metrics: nil, views: ["_contextLab":contextLab])
        self.addConstraints(conLabH)
        let conLabV = NSLayoutConstraint.constraints(withVisualFormat: "V:[_contextLab]-10-|", options: .alignmentMask, metrics: nil, views: ["_contextLab":contextLab])
        self.addConstraints(conLabV)

    }
    
    //MARK: - 异步加载图片
    func asyncDownLaodImage(imgUrl:String){
        
        /*
         * 这里先使用UserDefaults进行数据缓存，如果数据量比较大，就考虑使用SQLite
         */
        if let data = UserDefaults.standard.object(forKey: imgUrl) as? Data{
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.img.image = image
            }
        }else{
            //判断是否已经有图片和图片地址是否为空
            if imgUrl.count > 0, let url = URL(string: imgUrl){
                DispatchQueue.global().async {
                    if let data = NSData(contentsOf: url),let image = UIImage(data: data as Data){
                        UserDefaults.standard.set(data, forKey: imgUrl)
                        DispatchQueue.main.async {
                            self.img.image = image
                        }
                    }
                }
            }
        }
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
