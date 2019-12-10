package com.nostyling.create.util.test.list;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-11-18 14:59
 * @description:
 **/
public class ListGroupMap {

    public static void main(String[] args){
        List<User> list = getUserList();
        Map <String,List<User>> userGroupMap = list.stream().collect(Collectors.groupingBy(User::getType));
        System.out.println(userGroupMap.toString());
    }


    public static List <User> getUserList(){
        User user1 = new User(1,"张三","小学");
        User user2 = new User(2,"李四","小学");
        User user3 = new User(3,"王五","初中");
        User user4 = new User(4,"马六","高中");

        List<User> list = new ArrayList <User>();
        list.add(user1);
        list.add(user2);
        list.add(user3);
        list.add(user4);

        return list;
    }
    @Data
    static class User {
        private Integer id;
        private String name;
        private String type;

        public User() {
        }

        public User(Integer id, String name, String type) {
            this.id = id;
            this.name = name;
            this.type = type;
        }


    }
}
