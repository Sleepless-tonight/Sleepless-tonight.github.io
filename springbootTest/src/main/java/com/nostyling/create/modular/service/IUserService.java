package com.nostyling.create.modular.service;

import com.nostyling.create.modular.entity.User;

import java.util.List;
import java.util.Map;

/**
 * <p>
 * 管理员表 服务类
 * </p>
 *
 * @author yestae123
 * @since 2018-02-22
 */
public interface IUserService  {

    /**
     * 根据条件查询用户列表
     */
    List<User> selectUsers(User entity);

}
