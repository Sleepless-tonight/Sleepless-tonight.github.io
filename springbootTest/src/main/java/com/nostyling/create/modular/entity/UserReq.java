package com.nostyling.create.modular.entity;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;

/**
 * @ outhor: by com.nostyling.create.modular.entity
 * @ Created by shili on 2018/10/3 3:24.
 * @ 类的描述：
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
//加入@ApiModel
@ApiModel
public class UserReq {

    @ApiModelProperty(value="ID",dataType="String",name="ID",example="1020332806740959233")
    String id;

    /**
     * value–字段说明
     * name–接收参数名
     * dataType–参数的数据类型
     * required–是否必填
     * example–举例说明
     * hidden–隐藏
     */
    @ApiModelProperty(value="编码",dataType="String",name="code",example="001",required = true)
    @NotBlank(message = "编码不能为空")
    String code;

    /**
     * springboot注解: @NotNull，@NotBlank，@Valid自动判定空值
     * @NotNull：不能为null，但可以为empty
     *
     * @NotEmpty：不能为null，而且长度必须大于0
     *
     * @NotBlank：只能作用在String上，不能为null，而且调用trim()后，长度必须大于0
     * 案例：
     */
    @ApiModelProperty(value="名称",dataType="String",name="name",example="oKong")
    @NotBlank(message = "名称不能为空")
    String name;
}
