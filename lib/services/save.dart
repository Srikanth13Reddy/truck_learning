
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:truck_learning/services/presenter.dart';
import 'package:truck_learning/services/saveView.dart';
import 'package:truck_learning/utils/constants.dart';
import 'package:truck_learning/utils/network_utils.dart';
class SaveImpl implements Presenter
{
  var response;

  SaveView saveView;
  BuildContext context;

  SaveImpl(this.saveView,this.context);

  @override
  void handleSaveView(body,connection,type,mtype) {
    getData(body, connection,type,mtype);
  }

  void getData(body,connection,type,mtype)async
  {


        try{
          if(type=='GET')
          {
            response = await http
                .get(Base_Url+connection,
                headers: {'content-type': "application/json; charset=utf-8"});
          }
          else if(type=='POST')
          {
            response = await http
                .post(Base_Url+connection,
                body:body,
                headers: {'content-type': "application/json; charset=utf-8"});
          }
          else if(type=='PUT')
          {
            response = await http
                .put(Base_Url+connection,
                body:body,
                headers: {'content-type': "application/json; charset=utf-8"});
          }
          else if(type=='DELETE')
          {
            response = await http
                .delete(Base_Url+connection,
                headers: {'content-type': "application/json; charset=utf-8"});
          }


          print(response.body);
          print(response.statusCode);
          if(response.statusCode==200)
          {
            String response_=response.body.toString();
            saveView.onSuccess(response_,mtype);
          }else{
            saveView.onFailur('Something went wrong',response.body,response.statusCode);
          }
        }catch(e)
         {print(e);}




  }


}