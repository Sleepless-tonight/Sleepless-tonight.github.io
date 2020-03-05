//package com.nostyling.create.util.test.taobao;
//
//import com.taobao.api.ApiException;
//import com.taobao.api.DefaultTaobaoClient;
//import com.taobao.api.TaobaoClient;
//import com.taobao.api.request.TmcUserPermitRequest;
//import com.taobao.api.response.TmcUserPermitResponse;
//
///**
// * @program: Sleepless-tonight.github.io
// * @author: shiliang
// * @create: 2019-08-03 18:44
// * @description: 为已授权的用户开通消息服务
// **/
//public class Test14 {
//    public static void main(String[] args) throws ApiException {
//        String url = "https://eco.taobao.com/router/rest";
//        String appkey = "appkey";
//        String secret = "secret";
//        String sessionKey = "sessionKey";
//        TaobaoClient client = new DefaultTaobaoClient(url, appkey, secret);
//        TmcUserPermitRequest req = new TmcUserPermitRequest();
//        //消息主题列表，用半角逗号分隔。当用户订阅的topic是应用订阅的子集时才需要设置，不设置表示继承应用所订阅的所有topic，一般情况建议不要设置。
//        //req.setTopics("taobao_trade_TradeModifyFee," +
//        //        "taobao_refund_RefundCreate," +
//        //        "taobao_refund_RefundCreate," +
//        //        "taobao_refund_RefundCreate," +
//        //        "taobao_refund_RefundCreate," +
//        //        "taobao_refund_RefundCreate," +
//        //        "taobao_refund_RefundCreate," +
//        //        "taobao_refund_RefundCreate");
//        TmcUserPermitResponse rsp = client.execute(req, sessionKey);
//        System.out.println(rsp.getBody());
//        //{"tmc_user_permit_response":{"is_success":true,"request_id":"4mbvg6r87v8d"}}
//    }
//}
