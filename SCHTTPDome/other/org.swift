//
//  org.swift
//  Travel
//
//  Created by SHICHUAN on 2019/4/3.
//  Copyright © 2019 SHICHUAN. All rights reserved.
//

import Foundation

func http() -> () {
    
    var resqut = URLRequest(url: URL(string: "https://stanserver.cn/http/DaoUserXML/addUser.do")!)
    
    
    resqut.httpMethod = "POST"
    let boundary = "wfWiEWrgEFA9A78512weF7106A"
    resqut.allHTTPHeaderFields = ["Content-Type":"multipart/form-data; boundary=\(boundary)"]
    
    
    let postData = NSMutableData()
    
    var ppt = "--\(boundary)\r\nContent-Disposition: form-data; name=username\r\n\r\n"
    postData.append(ppt.data(using: String.Encoding.utf8)!)
    postData.append("hello word".data(using: String.Encoding.utf8)!)
    postData.append("\r\n".data(using: String.Encoding.utf8)!)
    
    
    ppt = "--\(boundary)\r\nContent-Disposition: form-data; name=file;filename=picture.png\r\n\r\n"
    postData.append(ppt.data(using: String.Encoding.utf8)!)
    
    let data = NSData.init(contentsOfFile: "/Users/SHICHUAN/Desktop/http-multipart.png")
    postData.append(data! as Data)
    
    postData.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
    resqut.httpBody = postData as Data
    resqut.setValue("\(postData.length)", forHTTPHeaderField: "Content-Length")
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    let task = session.dataTask(with: resqut) { (data, response, error) in
        print(String(data: data! , encoding: .utf8) as Any)
    }
    task.resume()
}
