package com.nostyling.create.util;


/**
 * @ outhor: by com.nostyling.create.util
 * @ Created by shiliang on 2018-10-25 11:04.
 * @ 类的描述：
 */
public class test3 {

    public static void main(String[] args) {

        //UserVo userVo = new UserVo();
        //userVo.id = "1";
        //userVo.name = "zzzz";
        //System.out.println(userVo.toString());

        int x;
        User user = new User();
        System.out.println(user.age);

    }




    static class User {
        protected String id;
         String name;
         int age;
    }


}
class UserVo {
    private String id;
    private String name;
    private String age;
}