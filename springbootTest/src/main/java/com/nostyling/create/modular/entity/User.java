package com.nostyling.create.modular.entity;

import lombok.Data;

import java.util.Date;

/**
 * @ outhor: by com.nostyling.create.modular.entity
 * @ Created by shiliang on 2018/8/21 14:37.
 * @ 类的描述：
 */
@Data
public class User {

    private int id;
    private String uuid;
    private String account;
    private String password;
    private String salt;
    private String name;
    private Date birthday;
    private int sex;
    private String address;
    private String qq;
    private String email;
    private String phone;
    private int status;
    private Date createtime;
    private int version;



}