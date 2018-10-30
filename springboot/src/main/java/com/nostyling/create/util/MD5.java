package com.nostyling.create.util;

import java.security.MessageDigest;

/**
 * @ outhor: by com.nostyling.create.util
 * @ Created by shiliang on 2018-10-25 17:52.
 * @ 类的描述：
 */
public class MD5 {
    public static void main(String[] args) throws Exception {
        String string = "8863982bc55f499ab9ed404d06d415cbappkey57b7be7c710743e7b0bf978a97972003bizcontent{\"orderstatus\":\"jh_02\",\"platorderno\":\"\",\"starttime\":\"2018-07-09 14:57:02\",\"endtime\":\"2018-07-16 16:57:02\",\"timetype\":\"jh_01\",\"pageindex\":\"1\",\"pagesize\":\"10\",\"shoptype\":\"jh_001\",\"ordertype\":\"jh_001\"}methoddiffer.jh.business.getordertokenea57adbade664ac3b78d7516bb96fd018863982bc55f499ab9ed404d06d415cb";
        byte[] parms = string.getBytes("UTF-8");
        MessageDigest md = MessageDigest.getInstance("MD5");
        //md.update(parms);
        byte[] bytes = md.digest(parms);
        //byte[] bytes = md.digest();
        StringBuilder result = new StringBuilder();
        for (int i = 0; i < bytes.length; i++) {
            String hex = String.format("%X", bytes[i]);
            if (hex.length() == 1) {
                result.append("0");
            }
            result.append(hex);
        }
        String binarytohexadecimal = result.toString();
        System.out.println(binarytohexadecimal);

        StringBuilder sb = new StringBuilder();
        for (byte item : bytes) {
            sb.append(Integer.toHexString((item & 0xFF) | 0x100).substring(1, 3));
        }
        System.out.println(sb.toString());
    }

}
