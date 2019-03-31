package com.nostyling.create.modular.service.impl;


import com.nostyling.create.modular.dao.UserMapper;
import com.nostyling.create.modular.entity.User;
import com.nostyling.create.modular.service.IUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * <p>
 * 管理员表 服务实现类
 * </p>
 *
 * @author yestae123
 * @since 2018-02-22
 */
@Service
public class UserServiceImpl implements IUserService {
	
	@Autowired
	private UserMapper userMapper;

    @Override
    public List<User> selectUsers(Map<String, Object> map) {
        return userMapper.selectUsers(map);
    }

}
