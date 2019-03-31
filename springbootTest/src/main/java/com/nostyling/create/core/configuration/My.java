package com.nostyling.create.core.configuration;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * @ outhor: by com.nostyling.create.core.configuration
 * @ Created by shili on 2018/9/11 1:15.
 * @ 类的描述：多配置项属于某一配置时，对应到一个实体配置类中
 */
@Component
//@EnableConfigurationProperties(value= {Config.class})
@ConfigurationProperties(prefix="my")
@Data
public class My {

    String code;

    String name;

    List<String> hobby;
}