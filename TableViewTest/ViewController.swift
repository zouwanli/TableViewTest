//
//  ViewController.swift
//  TableViewTest
//
//  Created by Zouwanli on 2019/3/5.
//  Copyright © 2019 Zouwanli. All rights reserved.
//

import UIKit
import ZhuoZhuo

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    private let indiLab = UILabel()
    private let indicator = UIActivityIndicatorView()
    private let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
    private var dataArray = [ResponseModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initUI()  //初始化界面
        self.getDataArray() //获取数据
    }
    
    //MARK: - 初始化界面UI
    private func initUI(){
        self.view.backgroundColor = ZwlRGBA(236, 237, 240, 1)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        //注册Header
        tableView.register(ZwlTestHeaderFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: "iZwlTestHeaderFooterView")
        
        /*
         * 开始加载动画和提示文本
         */
        self.indicator.frame = CGRect(x: (SCREEN_WIDTH-50)/2, y:(SCREEN_HEIGHT-70)/2, width: 50, height: 50)
        self.indiLab.frame = CGRect(x: (SCREEN_WIDTH-100)/2, y:(SCREEN_HEIGHT-70)/2+50, width: 100, height: 20)
        self.indiLab.font = UIFont.systemFont(ofSize: 14)
        self.indiLab.text = "正在加载数据..."
        self.indicator.hidesWhenStopped = true
        self.indicator.style = .gray
        self.view.addSubview(indicator)
        self.view.addSubview(indiLab)
        indicator.startAnimating()
    }
    
    //MAKR: - 获取数据
    private func getDataArray(){
        DispatchQueue.global().async {
            let array = RdTestGetResource__NotAllowedInMainThread()
            if let modelArray = array,modelArray.count > 0{
                self.dataArray += modelArray
            }
            DispatchQueue.main.async {
                self.indiLab.removeFromSuperview()
                self.indicator.stopAnimating()
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
    }

    //MARK: - UITableViewDataSource,UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = self.dataArray[section]
        return model.clickInfoList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "iZwlTestHeaderFooterView")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //复用的HeaderView在这里进行设置处理，包括背景颜色透明处理
        let model = self.dataArray[section]
        let headerView = view as? ZwlTestHeaderFooterView
        headerView?.titleLab.text = model.title
        headerView?.contextLab.text = model.context
        
        /*
         * 设置图片的位置
         */
        if model.imageSizeInfo.height > 0 && model.imageSizeInfo.width > 0 {
            
            //一般不建议这里处理，会影响加载性能
            headerView?.img.frame = CGRect(x: 10, y: 40, width: model.imageSizeInfo.width, height: model.imageSizeInfo.height)
            headerView?.img.isHidden = false
            headerView?.asyncDownLaodImage(imgUrl: model.imageUrl)
        }else{
            headerView?.img.isHidden = true
        }

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        let model = self.dataArray[section]

        /*
         * 动态的计算contextLab的高度
         */
        var height:CGFloat = 50+20+1
        if model.context.count > 0{
            
            let labHeight = self.get_heightForComment(str: model.context, font:UIFont.systemFont(ofSize: 14), width: SCREEN_WIDTH-20)
            height = 50+labHeight+10+1
        }
        
        /*
         * 计算图片的高度
         */
        if model.imageSizeInfo.height > 0{
            height += CGFloat(model.imageSizeInfo.height)
        }
        return height
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //点击Cell的高度
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.dataArray[indexPath.section]
        let clickInfo = model.clickInfoList[indexPath.row]
        let cell = ZwlClickInfoCell.zwlClickInfoCellWithTableView(tableView: tableView)
        cell.targetLab.text = clickInfo.targetString
        cell.urlLab.text = clickInfo.url
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataArray[indexPath.section]
        let clickInfo = model.clickInfoList[indexPath.row]
        
        DispatchQueue.main.async {
            let title = "你要打开此网页?"
            let alertView = UIAlertController(title:title,
                                              message:clickInfo.url,
                                              preferredStyle: .alert)
            
            
            let cancel = UIAlertAction(title:NSLocalizedString("取消", comment: ""), style: .cancel, handler: {
                action in
                
            })
            let done = UIAlertAction(title:NSLocalizedString("确定", comment: ""), style: .default, handler: {
                action in
                if let url = URL(string: clickInfo.url){
                    //根据iOS系统版本，分别处理
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:],
                                                  completionHandler: {
                                                    (success) in
                        })
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            })
            
            //修改取消按钮颜色
            cancel.setValue(UIColor.black, forKey: "titleTextColor")
            
            //修改确定按钮颜色
            done.setValue(UIColor.red, forKey: "titleTextColor")
            
            alertView.addAction(cancel)
            alertView.addAction(done)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    


    //MARK: - 计算文字的高度
    private func get_heightForComment(str:String, font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: str).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)
    }
}
