package com.nostyling.create.util.test;

import java.io.IOException;
import java.util.concurrent.TimeUnit;

import okhttp3.Call;
import okhttp3.FormBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
/**
 * @ outhor: by com.nostyling.create.util
 * @ Created by shiliang on 2018/10/17 19:23.
 * @ 类的描述：OkHttpClient
 */
public class test {
    public static void main(String[] args) throws IOException {
        RequestBody body = new FormBody.Builder()
                .add("sign", "755086ba29c6548f9c96be70a4a6d22c")
                .add("method", "Differ.JH.Business.GetOrder")
                .add("appkey","57b7be7c710743e7b0bf978a97972003")
                .add("token","ea57adbade664ac3b78d7516bb96fd01")
                .add("bizcontent","{\"OrderStatus\":\"JH_02\",\"PlatOrderNo\":\"\",\"StartTime\":\"2018-07-09 14:57:02\",\"EndTime\":\"2018-07-16 16:57:02\",\"TimeType\":\"JH_01\",\"PageIndex\":\"1\",\"PageSize\":\"10\",\"ShopType\":\"JH_001\",\"OrderType\":\"JH_001\"}")
//			    .add("StartTime","2018-07-09 14:57:02")
//			    .add("PlatOrderNo","1018755914039017473")
                .add("PageIndex","1")
                .add("PageSize","10")
                .build();

        Request request = new Request.Builder()
                .url("http://localhost:8080/user/Center")
                .post(body)
                .build();

        Call call = new OkHttpClient().newBuilder()
                .connectTimeout(10, TimeUnit.SECONDS)
                .readTimeout(10, TimeUnit.SECONDS)
                .writeTimeout(10, TimeUnit.SECONDS)
                .build().newCall(request);

        Response response = call.execute();
        String string = response.body().string();

        System.err.println(string);
    }
}
