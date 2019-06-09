package com.nostyling.create.modular.dao;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nostyling.create.modular.entity.User;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * <p>
 * 管理员表 Mapper 接口
 * </p>
 *
 * @author yestae
 * @since 2017-07-11
 */
public interface UserMapper extends BaseMapper<User> {
    /**
     * 根据条件查询用户列表
     */
	List<User> selectUsers(User entity);


}