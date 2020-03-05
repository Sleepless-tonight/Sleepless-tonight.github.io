//package com.nostyling.create.util.test.taobao;
//
//import com.taobao.api.ApiException;
//import com.taobao.api.DefaultTaobaoClient;
//import com.taobao.api.TaobaoClient;
//import com.taobao.api.request.TmcUserGetRequest;
//import com.taobao.api.response.TmcUserGetResponse;
//
///**
// * @program: Sleepless-tonight.github.io
// * @author: shiliang
// * @create: 2019-08-03 18:35
// * @description: 获取用户已开通消息
// **/
//public class Test12 {
//    public static void main(String[] args) throws ApiException {
//        String url = "https://eco.taobao.com/router/rest";
//        String appkey = "appkey";
//        String secret = "secret";
//        TaobaoClient client = new DefaultTaobaoClient(url, appkey, secret);
//        TmcUserGetRequest req = new TmcUserGetRequest();
//        req.setFields("user_nick,topics,user_id,is_valid,created,modified");
//        req.setNick("testnick");
//        //用户所属的平台类型，tbUIC:淘宝用户; icbu: icbu用户;ae:ae用户
//        req.setUserPlatform("tbUIC");
//        TmcUserGetResponse rsp = client.execute(req);
//        System.out.println(rsp.getBody());
//    }
//}
