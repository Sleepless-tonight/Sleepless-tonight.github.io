package com.nostyling.create.util.test;

import com.alibaba.fastjson.JSONObject;

import java.time.Instant;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-04-02 17:50
 * @description:
 **/
public class Test1001 {
    public static void main(String[] args) {
        String json = "{\"orders\":[{\"PlatOrderNo\":\"1903181747073149610\",\"tradeStatus\":\"JH_99\",\"tradeStatusdescription\":\"\\u7b49\\u5f85\\u5356\\u5bb6\\u53d1\\u8d27\",\"tradetime\":\"2019-03-18 17:47:07\",\"payorderno\":\"\",\"country\":\"CN\",\"province\":\"\\u9ed1\\u9f99\\u6c5f\",\"city\":\"\\u4f73\\u6728\\u65af\\u5e02\",\"area\":\"\\u629a\\u8fdc\\u53bf\",\"town\":\"\",\"address\":\"\\u6d4b\\u8bd5\\u5730\\u503c\",\"zip\":\"\",\"mobile\":\"17012554565\",\"email\":\"\",\"customerremark\":\"\",\"sellerremark\":\"\",\"postfee\":0,\"goodsfee\":\"2.00\",\"totalmoney\":\"2.00\",\"favourablemoney\":0,\"commissionvalue\":0,\"taxamount\":0,\"tariffamount\":0,\"addedvalueamount\":0,\"consumptiondutyamount\":0,\"sendstyle\":\"\\u666e\\u901a\\u5feb\\u9012\",\"qq\":\"\",\"paytime\":\"2019-03-18 17:47:14\",\"invoicetitle\":\"\",\"taxpayerident\":\"\",\"codservicefee\":0,\"cardtype\":\"JH_01\",\"idcard\":\"\",\"idcardtruename\":\"\\u738b\\u4e3d\\u5357\",\"receivername\":\"wangli\",\"nick\":\"\\u738b\\u4e3d\\u5357\",\"whsecode\":\"KMLX001\",\"IsHwgFlag\":0,\"ShouldPayType\":\"\\u73b0\\u91d1\\u6536\\u6b3e\",\"goodinfos\":[{\"ProductId\":\"1fc6b798a961646069c306d6fd6449b9\",\"suborderno\":\"\",\"tradegoodsno\":\"15665456\",\"tradegoodsname\":\"9989889\",\"tradegoodsspec\":\"\",\"goodscount\":\"1\",\"price\":\"2.00\",\"discountmoney\":0,\"taxamount\":0,\"refundStatus\":\"JH_07\",\"Status\":\"JH_02\",\"remark\":\"\"}]}],\"numtotalorder\":802,\"code\":\"10000\",\"message\":\"SUCCESS\"}";
        //String st2 = new String(json.getBytes());
        //System.out.println(st2);


        JSONObject jsonObject= JSONObject.parseObject(json);
        System.out.println(jsonObject.toJSONString());
    }
}
