
import 'dart:io';

void main()  async{
  HttpServer httpServer = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  print('监听 localhost地址，端口号为${httpServer.port}');

  await for (HttpRequest  server in httpServer) {
      handlerMessage(server);   
  }

}


void handlerMessage(HttpRequest request){
  try {
    if(request.method == 'GET'){
    handlerGet(request);
  }else if(request.method=='POST'){
      //获取到POST请求
      handlerPOST(request);
    }else{
      //其它的请求方法暂时不支持，回复它一个状态
      request.response..statusCode=HttpStatus.methodNotAllowed
          ..write('对不起，不支持${request.method}方法的请求！')
          ..close();
    }
  } catch (e) {
    request.response..statusCode =HttpStatus.internalServerError
    ..write('服务器错误')
    ..close();
  }
  
}

void handlerGet(HttpRequest request){
  var token = request.uri.queryParameters['token'];
  request.response
  ..statusCode = HttpStatus.ok
  ..write('请求token是$token')
  ..close();

}

void handlerPOST(HttpRequest request){
  var token = request.uri.queryParameters['token'];
  request.response
  ..statusCode = HttpStatus.ok
  ..write('请求token是$token')
  ..close();

}

void writeHeaders(HttpRequest request){
  List<String> headers = [];
  request.headers.forEach((key,values){
    String header = '$key: ';
    for(String value in values){
      header = header + '$value';
    }
    headers.add(header.substring(0,header.length));
  });
  // print('打印header');
  // print(headers.join('\n'));
  writeLog('${headers.join('\n')}');
}

void writeLog(String log) async{
  var date=DateTime.now();
  var year=date.year;
  var month=date.month;
  var day=date.day;
  var hour=date.hour;
  var minute=date.minute;

  //如果recursive为true，会创建命名目录及父级目录
  Directory directory=await new Directory('bin/log/$year-$month-$day').create(recursive: true);

  File file = new File('${directory.path}/$hour:$minute.log');
  file.exists().then((isExists){
    String logAddTime='time：${date.toIso8601String()}\n$log';
     file.writeAsString(isExists?'\n\n$logAddTime':logAddTime, mode: FileMode.append);
  });
}