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

    @ApiModelProperty(value="编码",dataType="String",name="code",example="001")
    @NotBlank(message = "编码不能为空")
    String code;

    @ApiModelProperty(value="名称",dataType="String",name="name",example="oKong")
    @NotBlank(message = "名称不能为空")
    String name;
}
