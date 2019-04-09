
# How to use multipart/form-data in swift


 <h3>说明</h3>
 这个是一个HTTP发送文件的类
 按照HTTP发送文件格式用 “swift”拼接然后发送
 HTTP 文件发送的格式和普通的字符串发送，最大的区别就是有一个自定义的分割符号
 来分割不同的发送部分，
 
 <h3>请注意</h3>
 本类中参数的设置非常严格，如果你要发送字符串
 MediaType.String
 参数梨必须有两个参数 name 和 sentStr
 如果是发送文件
 MediaType.File
 参数梨必须有两个参数  fileName 和 data
 
 
 
 
 
 
 <h1>Instruction</h1>
 
 This is a class that sends files over HTTP
 Send file format as HTTP with “swift” splicing and then send
 HTTP files are sent in a format that is different from regular strings in that they have a custom split symbol
 To separate the different sending parts
 

 <h3>Attention please</h3>
 The parameters in this class are set very strictly if you want to send a string
 MediaType.String
 The pear must have two arguments, "name" and "sentStr"
 If you are sending a file
 MediaType.File
 The parameter pear must have two parameters "fileName" and "filePath"

  
  
  <h1>How to get start</h1>
  <h5>Put "SCHTTP. Swift" in your project</h5>
 
<pre>
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
             data:img1)
             
            (name:"name",
             fileName:"picture2",
             mediaType:SCHTTP.MediaType.File,
             string:nil,
             data:img2)
        ]
        request.star(request:request)
        request.SCHTTPDelegate = self    
</pre>    
        
  <h1>How to get Return data</h1>        
  <h5>Yow wille get data in SCHTTPDelegate</h5>
  
  <pre>
  func didSCHTTPFinished(data: Data?, response: URLResponse?, error: Error?) {
  
        if let jsonString = String(data: data!, encoding: String.Encoding.utf8){
         print(jsonString)
         
      }
    }
  
  </pre>
  
  # Org code
  <pre>

//  SCHTTP.swift
//  Created by SHICHUAN on 2019/4/2.
//  Copyright © 2019 SHICHUAN. All rights reserved.


import Foundation
/*
 请求返回数据
 Request return data
 */
protocol SCHTTPDelegate{
    func didSCHTTPFinished(data:Data?,response:URLResponse?,error:Error?) -> ()
}


public class SCHTTP:NSObject,Error,URLSessionTaskDelegate{
    
  
    /*
     目前在swift中要使用URLSessionTaskDelegate，要是NSObject的子类
     Currently in swift you use URLSessionTaskDelegate, which is a subclass of NSObject
     */
     public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64)
     {
        let progress = Float(totalBytesSent)/Float(totalBytesExpectedToSend)
   
        if progress >= 1 {
            print("----OK----task finished request well done----------")
        }

        print( "progress: \(String(format: "%.2f",progress))")
    }
    
    
    
    public enum BuildError: Error{
        case NOURLError
        case NOParameterError
        case NOnameError
        case NOfileNameError
        case NOmediaTypeError
        case NOstringError
        case NODataError
    }
    public enum MediaType {
        case String
        case File
    }
    public typealias Parameter = (
        name:String?,
        fileName:String?,
        mediaType:MediaType?,
        string:String?,
        data:Data?
    )
    
    var url:String?
    var parameter:[Parameter]?
    var SCHTTPDelegate:SCHTTPDelegate?
    
    
    
    public func star(request:SCHTTP)->(){
        do{
            try request.requeststar()
        }catch SCHTTP.BuildError.NOURLError{
            print("SCHTTP.BuildError.NOURLError")
        }catch SCHTTP.BuildError.NOParameterError{
            print("SCHTTP.BuildError.NOParameterError")
        }catch SCHTTP.BuildError.NOnameError{
            print("SCHTTP.BuildError.NOnameError")
        }catch SCHTTP.BuildError.NOfileNameError{
            print("SCHTTP.BuildError.NOfileNameError")
        }catch SCHTTP.BuildError.NOmediaTypeError{
            print("SCHTTP.BuildError.NOmediaTypeError")
        }catch SCHTTP.BuildError.NOstringError{
            print("SCHTTP.BuildError.NOstringError")
        }catch SCHTTP.BuildError.NODataError{
            print("SCHTTP.BuildError.NODataError")
        }catch{
            print("SCHTTP.nuknowErron")
        }
    }
    
    
    private func requeststar() throws ->(){
        
        let formatData = NSMutableData()
        let boundary = "wfWiEWrgEFA9A78512weF7106A"
        
        
        if let url = url{
            if let parameter = parameter{
                var request = URLRequest(url:URL(string:url)!)
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = ["Content-Type":"multipart/form-data;boundary=\(boundary)"]
                
                for item in parameter{
                    /*
                     拼接要发送的字符串
                     Concatenate the string to be sent
                     */
                    if case item.mediaType = MediaType.String{
                        if let str = item.string{
                            if let name = item.name{
                                formatData.append(sentStr(sentStr: str, name: name, boundary: boundary) as Data)
                            }else{
                                throw BuildError.NOnameError
                            }
                        }else{
                            throw BuildError.NOstringError
                        }
                    }
                    /*
                     拼接要发送的文件
                     Splicing the file to be sent
                     */
                    if case item.mediaType = MediaType.File{
                        if let name = item.name{
                            if let fileName = item.fileName{
                                if let data = item.data{
                                    formatData.append(sentFile(name: name, fileName: fileName, data:data, boundary: boundary) as Data)
                                }else{
                                    throw BuildError.NODataError
                                }
                                
                            }else{
                                throw BuildError.NOfileNameError
                            }
                        }else{
                            throw BuildError.NOfileNameError
                        }
                    }
                }
                
                formatData.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
                request.httpBody = formatData as Data
                request.setValue("\(formatData.length)", forHTTPHeaderField: "Content-Length")
                let session = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
                print(session)
                let task = session.dataTask(with: request) { (data, response, error) in
                    print("1")
                    self.SCHTTPDelegate?.didSCHTTPFinished(data: data, response: response, error: error)
                }
                task.resume()
                print("2")
            }else{
                throw BuildError.NOParameterError
            }
        }else{
            throw BuildError.NOURLError
        }
        print("3")
    }
    
    
    
    
    
    /*
     按照HTTP格式拼接要发送的文字
     Concatenate the text to be sent in HTTP format
     */
    private func sentStr(sentStr:String,name:String,boundary:String) -> (NSData) {
        
        var formatStr = "--\(boundary)\r\nContent-Disposition: form-data; name=\(name)\r\n\r\n"
        formatStr.append(sentStr)
        formatStr.append("\r\n")
        
        return formatStr.data(using: String.Encoding.utf8)! as (NSData)
    }
    /*
     按照HTTP格式拼接要发送的文件
     Concatenate the files to be sent in HTTP format
     */
    private func sentFile(name:String,fileName:String,data:Data,boundary:String)->(NSData){
        
        let formatData = NSMutableData()
        let formatStr = "--\(boundary)\r\nContent-Disposition: form-data; name=\(fileName);filename=\(name)\r\n\r\n"
        formatData.append(formatStr.data(using: String.Encoding.utf8)!)
        formatData.append(data)
        formatData.append("\r\n".data(using: String.Encoding.utf8)!)
        return formatData        
    }
    
    
    /*
     HTTPS 验证文件的处理
     HTTPS validates file processing
     */
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        print("urlSession")
        
        let path = Bundle.main.path(forResource: "certificate", ofType: "cer");
        let url = URL(fileURLWithPath: path!)
        do {
            
            let localCertificateData = try Data(contentsOf: url)
            
            if let serverTrust = challenge.protectionSpace.serverTrust,
                let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                let remoteCertificateData: Data = SecCertificateCopyData(certificate) as Data
                
                print("remoteCertificateData:\(remoteCertificateData.base64EncodedString())")
                print("localCertificateData:\(localCertificateData.base64EncodedString())")
                
                
                /*
                 证书校验：这里直接比较本地证书文件内容 和 服务器返回的证书文件内容
                 Certificate validation: this directly compares the contents of the local certificate file with the contents of the certificate file returned by the server
                 */
                if localCertificateData as Data == remoteCertificateData {
                    
                    let credential = URLCredential(trust: serverTrust)
                    challenge.sender?.use(credential, for: challenge)
                    /*
                     证书校验通过
                     Certificate verified
                     */
                    print("Certificate verified")
                    completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, credential)
                } else {
                    challenge.sender?.cancel(challenge)
                    
                    /*
                     证书校验不通过
                     The certificate does not pass the check
                     */
                    print("The certificate does not pass the check")
                    completionHandler(Foundation.URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
                }
            } else {
                // could not tested
                print("Pitaya: Get RemoteCertificateData or LocalCertificateData error!")
            }
        }catch{
            
        }
    }
    
    
    
    
}

  </pre>
