# swift-multipart-form-data
How to use multipart/form-data in swift

 这个是一个HTTP发送文件的类
 按照HTTP发送文件格式用 “swift”拼接然后发送
 HTTP 文件发送的格式和普通的字符串发送，最大的区别就是有一个自定义的分割符号
 来分割不同的发送部分，
 
 请注意
 本类中参数的设置非常严格，如果你要发送字符串
 MediaType.String
 参数梨必须有两个参数 name 和 sentStr
 如果是发送文件
 MediaType.File
 参数梨必须有两个参数  fileName 和 data
 
 
 
 This is a class that sends files over HTTP
 Send file format as HTTP with “swift” splicing and then send
 HTTP files are sent in a format that is different from regular strings in that they have a custom split symbol
 To separate the different sending parts
 
 Attention please
 The parameters in this class are set very strictly if you want to send a string
 MediaType.String
 The pear must have two arguments, "name" and "sentStr"
 If you are sending a file
 MediaType.File
 The parameter pear must have two parameters "fileName" and "filePath"

  
  
  <h5>How to get start</h5>
  
  
  
