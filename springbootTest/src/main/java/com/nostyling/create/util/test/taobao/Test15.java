package com.nostyling.create.util.test.taobao;

import com.taobao.api.ApiException;
import com.taobao.api.BatchTaobaoClient;
import com.taobao.api.DefaultTaobaoClient;
import com.taobao.api.TaobaoBatchRequest;
import com.taobao.api.TaobaoBatchResponse;
import com.taobao.api.TaobaoClient;
import com.taobao.api.internal.util.StringUtils;
import com.taobao.api.request.TradeFullinfoGetRequest;
import com.taobao.api.request.TradesSoldGetRequest;
import com.taobao.api.request.TradesSoldIncrementGetRequest;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-09-03 11:18
 * @description: 批量淘宝API
 **/
public class Test15 {
    final static String url = "http://gw.api.taobao.com/router/rest";
    final static String appkey = "appkey";
    final static String secret = "secret";
    final static String sessionKey = "sessionKey";
    final static String tradeFields = "seller_nick,payment,post_fee,receiver_name,receiver_state, receiver_address, receiver_zip, receiver_mobile, receiver_phone, consign_time, received_payment, est_con_time, receiver_country, receiver_town, paid_coupon_fee, cloud_store, tid, num, num_iid, status, title, type, price, discount_fee, has_post_fee, total_fee, created, pay_time, modified, end_time, buyer_message, buyer_memo, buyer_flag, seller_memo, seller_flag, buyer_nick, credit_card_fee, step_trade_status, step_paid_fee, mark_desc, shipping_type, buyer_cod_fee, adjust_fee, trade_from, service_orders, receiver_city, receiver_district, orders, coupon_fee, assembly, nr_shop_id, nr_shop_name, buyer_open_uid, buyer_open_uid";

    public static void main(String[] args) {
        //创建TOP Client
        BatchTaobaoClient batchClient = new BatchTaobaoClient(url, appkey, secret);
        //全量
        //TradesSoldGetRequest req = new TradesSoldGetRequest();

        //增量
        //TradesSoldIncrementGetRequest reqAdd = new TradesSoldIncrementGetRequest();

        //详情
        TradeFullinfoGetRequest reqALL = new TradeFullinfoGetRequest();

        // 创建批量请求对象
        TaobaoBatchRequest taobaoBatchRequest = new TaobaoBatchRequest();
        // 创建提取数据字段
        taobaoBatchRequest.addPublicParam("fields",tradeFields);
        taobaoBatchRequest.addPublicParam("method","taobao.trade.fullinfo.get");
        taobaoBatchRequest.setPublicMethod("taobao.trade.fullinfo.get");

        TradeFullinfoGetRequest tradeFullinfoGetRequest = new TradeFullinfoGetRequest();
        tradeFullinfoGetRequest.setTid(606596162074982868L);
        TradeFullinfoGetRequest tradeFullinfoGetRequest2 = new TradeFullinfoGetRequest();
        tradeFullinfoGetRequest2.setTid(606510944722660236L);

        taobaoBatchRequest.addRequest(tradeFullinfoGetRequest)
                .addRequest(tradeFullinfoGetRequest2);

        try {
            TaobaoBatchResponse execute = batchClient.execute(taobaoBatchRequest, sessionKey);
            System.out.println(execute.getBody());

        } catch (ApiException e) {
            e.printStackTrace();
        }



    }
}
