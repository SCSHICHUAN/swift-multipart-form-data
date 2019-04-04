//
//  ViewController.swift
//  Travel
//
//  Created by SHICHUAN on 2019/3/22.
//  Copyright © 2019 SHICHUAN. All rights reserved.
//

import UIKit

class ViewController: UIViewController,SCHTTPDelegate{
    lazy var login:UIButton = {
        let t = UIButton(type: UIButton.ButtonType.custom)
        t.frame = CGRect(x: 10, y: 250, width:UIScreen.main.bounds.width-20, height: 60)
        t.backgroundColor = UIColor.white
        t.setTitle("发送HTTP文件和字符串上传请求", for: .normal)
        t.layer.cornerRadius = 5
        t.setTitleColor(.black, for: .normal)
        t.setTitleColor(.red, for:.highlighted)
        t.addTarget(self, action: #selector(logint), for: .touchUpInside)
        return t
    }()
    
    
    
    
    
    @objc func logint() ->(){
        
        
        let img1 = UIImage.init(named: "he.jpeg")?.jpegData(compressionQuality: 1)
        let img2 = UIImage.init(named: "item.png")?.jpegData(compressionQuality: 1)
        
        
        let request = SCHTTP()
        request.url = "https://stanserver.cn/http/DaoUserXML/addUser.do"
        request.parameter = [
            
            (name:"username",
             fileName:nil,
             mediaType:SCHTTP.MediaType.String,
             string:"马云",
             data:nil),
            
            (name:"password",
             fileName:nil,
             mediaType:SCHTTP.MediaType.String,
             string:"15454454545",
             data:nil),
            
            (name:"name",
             fileName:"picture1",
             mediaType:SCHTTP.MediaType.File,
             string:nil,
             data:img1),

            (name:"name",
             fileName:"picture2",
             mediaType:SCHTTP.MediaType.File,
             string:nil,
             data:img2)
        ]
        
        
        request.star(request:request)
        request.SCHTTPDelegate = self
        
    }
    
    func didSCHTTPFinished(data: Data?, response: URLResponse?, error: Error?) {
        
        if let jsonString = String(data: data!, encoding: String.Encoding.utf8){
            print(jsonString)
        }

        DispatchQueue.main.async {
            let dict = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
            if dict != nil {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: (dict as! NSDictionary)["image1"] as! String)!)
                } else {
                    // Fallback on earlier versions
                }

            }
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(login)
        view.backgroundColor = UIColor.lightGray
    }
}
