import 'dart:io';

import 'package:http_server/http_server.dart';

import 'server01.dart';

main() async{

  var requestServer = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  
  await for(HttpRequest request in requestServer){
      writeHeaders(request);
      handlerRouter(request);
      
  }



}

void  handlerRouter(HttpRequest request){
  var url = request.uri;
  print('请求的地址是$url');
    if(url.toString() == '/'|| url.toString() == '/index.html' ){
  
        var staticFiles =  new VirtualDirectory('.');    
        // windows    
        staticFiles.serveFile(new File('webApp/index.html'),request);        
        // linux
        // staticFiles.serveFile(new File('../webApp/index.html'),request);        
    }
    else{
      handlerMessage(request);
    }
}