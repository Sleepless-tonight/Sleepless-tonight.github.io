<%--
  Created by IntelliJ IDEA.
  User: shili
  Date: 2017/11/3
  Time: 9:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script type="text/javascript" src="resources/static/js/common/jquery-1.11.0.min.js"></script>
<script type="text/javascript">
    var leftNavData = {
        "success": true,
        "message": "操作成功 ！",
        "error": "",
        "data": [
            {
                id: "100000",
                createdby: null,
                createdat: null,
                lastchangedby: null,
                lastchangedat: null,
                deletetag: 0,
                menuCode: "GZZX",
                menuName: "系统监控",
                parentId: "1",
                attribute: "iconfont-jiankong",
                url: "javascript:void0",
                sequence: 1,
                level: 2,
                subMenu: [
                    {
                        id: "101000",
                        createdby: null,
                        createdat: null,
                        lastchangedby: null,
                        lastchangedat: null,
                        deletetag: 0,
                        menuCode: "YWDB",
                        menuName: "实时监控",
                        parentId: "100000",
                        attribute: "",
                        url: "javascript:void0",
                        sequence: 1,
                        level: 3,
                        subMenu: [
                            {
                                id: "101010",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "WFQD",
                                menuName: "系统监控",
                                parentId: "101000",
                                attribute: null,
                                url: "system/realTime/time-xitong.html",
                                sequence: 15,
                                level: 3,
                                subMenu: null
                            },
                            {
                                id: "101020",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "WFQD",
                                menuName: "进程监控",
                                parentId: "101000",
                                attribute: null,
                                url: "system/realTime/starrySky.html",
                                sequence: 15,
                                level: 3,
                                subMenu: null
                            },
                            {
                                id: "101030",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "WFQD",
                                menuName: "系统负载监控",
                                parentId: "101000",
                                attribute: null,
                                url: "system/realTime/system-load.html",
                                sequence: 15,
                                level: 3,
                                subMenu: null
                            }
                        ]
                    },
                    {
                        id: "102000",
                        createdby: null,
                        createdat: null,
                        lastchangedby: null,
                        lastchangedat: null,
                        deletetag: 0,
                        menuCode: "WFQD",
                        menuName: "操作系统",
                        parentId: "100000",
                        attribute: null,
                        url: "system/countfile/operatingsystem.html",
                        sequence: 15,
                        level: 3,
                        subMenu: null
                    },
                    {
                        id: "103000",
                        createdby: null,
                        createdat: null,
                        lastchangedby: null,
                        lastchangedat: null,
                        deletetag: 0,
                        menuCode: "WFQD",
                        menuName: "应用系统",
                        parentId: "100000",
                        attribute: null,
                        url: "system/countfile/applysystem.html",
                        sequence: 15,
                        level: 3,
                        subMenu: null
                    },
                    {
                        id: "104000",
                        createdby: null,
                        createdat: null,
                        lastchangedby: null,
                        lastchangedat: null,
                        deletetag: 0,
                        menuCode: "WFQD",
                        menuName: "数据库",
                        parentId: "100000",
                        attribute: null,
                        url: "system/countfile/database.html",
                        sequence: 15,
                        level: 3,
                        subMenu: null
                    },
                    {
                        id: "105000",
                        createdby: null,
                        createdat: null,
                        lastchangedby: null,
                        lastchangedat: null,
                        deletetag: 0,
                        menuCode: "WFQD",
                        menuName: "用户数",
                        parentId: "100000",
                        attribute: null,
                        url: "system/countfile/userdata.html",
                        sequence: 15,
                        level: 3,
                        subMenu: null
                    },
                    {
                        id: "106000",
                        createdby: null,
                        createdat: null,
                        lastchangedby: null,
                        lastchangedat: null,
                        deletetag: 0,
                        menuCode: "WFQD",
                        menuName: "数据量",
                        parentId: "100000",
                        attribute: null,
                        url: "system/countfile/datasize.html",
                        sequence: 15,
                        level: 3,
                        subMenu: null
                    },
                    {
                        id: "107000",
                        createdby: null,
                        createdat: null,
                        lastchangedby: null,
                        lastchangedat: null,
                        deletetag: 0,
                        menuCode: "WFQD",
                        menuName: "巡检",
                        parentId: "100000",
                        attribute: null,
                        url: "javascript:void0",
                        sequence: 15,
                        level: 3,
                        subMenu: [
                            {
                                id: "107010",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "WFQD",
                                menuName: "日报",
                                parentId: "107000",
                                attribute: null,
                                url: "system/analysis/dayreport.html",
                                sequence: 15,
                                level: 3,
                                subMenu: null
                            },
                            {
                                id: "107020",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "WFQD",
                                menuName: "日报查询",
                                parentId: "107000",
                                attribute: null,
                                url: "system/analysis/dayreportView.html",
                                sequence: 15,
                                level: 3,
                                subMenu: null
                            },
                            {
                                id: "107030",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "WFQD",
                                menuName: "月报",
                                parentId: "107000",
                                attribute: null,
                                url: "system/analysis/monreport.html",
                                sequence: 15,
                                level: 3,
                                subMenu: null
                            },
                            {
                                id: "107040",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "WFQD",
                                menuName: "月报查询",
                                parentId: "107000",
                                attribute: null,
                                url: "system/analysis/monreportview.html",
                                sequence: 15,
                                level: 3,
                                subMenu: null
                            },
                        ]
                    },
                    {
                        id: "108000",
                        createdby: null,
                        createdat: null,
                        lastchangedby: null,
                        lastchangedat: null,
                        deletetag: 0,
                        menuCode: "WFQD",
                        menuName: "AWR & NMON",
                        parentId: "100000",
                        attribute: null,
                        url: "system/analysis/thirdPart.html",
                        sequence: 15,
                        level: 3,
                        subMenu: null

                        /* {
                             id: "108010",
                             createdby: null,
                             createdat: null,
                             lastchangedby: null,
                             lastchangedat: null,
                             deletetag: 0,
                             menuCode: "WFQD",
                             menuName: "管理报表",
                             parentId: "108000",
                             attribute: null,
                             url: "system/analysis/manreport.html",
                             sequence: 15,
                             level: 3,
                             subMenu: null
                         },*/


                    }
                ]
            },
            {
                id: "200000",
                createdby: null,
                createdat: null,
                lastchangedby: null,
                lastchangedat: null,
                deletetag: 0,
                menuCode: "GRSZ",
                menuName: "接口监控",
                parentId: "1",
                attribute: "jiekou",
                url: "jkpic/flowchart/dom.html",
                sequence: 2,
                level: 2,
                subMenu: [
                    {
                        id: "201000",
                        createdby: null,
                        createdat: null,
                        lastchangedby: null,
                        lastchangedat: null,
                        deletetag: 0,
                        menuCode: "MRZSD",
                        menuName: "连通状态监控",
                        parentId: "200000",
                        attribute: null,
                        url: "port/realTime/dom.html",
                        sequence: 2,
                        level: 3,
                        subMenu: null
                    },
                    {
                        id: "202000",
                        createdby: null,
                        createdat: null,
                        lastchangedby: null,
                        lastchangedat: null,
                        deletetag: 0,
                        menuCode: "GRXX",
                        menuName: "日报表",
                        parentId: "200000",
                        attribute: null,
                        url: "port/analysis/messAnaly.html",
                        sequence: 1,
                        level: 3,
                        subMenu: null
                    },
                    {
                        id: "203000",
                        createdby: null,
                        createdat: null,
                        lastchangedby: null,
                        lastchangedat: null,
                        deletetag: 0,
                        menuCode: "GRXX",
                        menuName: "管理报表",
                        parentId: "200000",
                        attribute: null,
                        url: "port/analysis/managereport.html",
                        sequence: 1,
                        level: 3,
                        subMenu: null
                    }

                ]
            },
            {
                id: "300000",
                createdby: null,
                createdat: null,
                lastchangedby: null,
                lastchangedat: null,
                deletetag: 0,
                menuCode: "GRSZ",
                menuName: "关键业务监控",
                parentId: "1",
                attribute: "yewu",
                url: "javascript:void0",
                sequence: 2,
                level: 2,
                subMenu: [
                    {
                        id: "301000",
                        createdby: null,
                        createdat: null,
                        lastchangedby: null,
                        lastchangedat: null,
                        deletetag: 0,
                        menuCode: "GRXX",
                        menuName: "信用监控",
                        parentId: "300000",
                        attribute: null,
                        url: "javascript:void0",
                        sequence: 1,
                        level: 3,
                        subMenu: [
                            {
                                id: "301010",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "XYSS",
                                menuName: "实时监控",
                                parentId: "301000",
                                attribute: null,
                                url: "business/credit/creditTime.html",
                                sequence: 1,
                                level: 4,
                                subMenu: null
                            },
                            {
                                id: "301020",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "XYFX",
                                menuName: "分析管理",
                                parentId: "301000",
                                attribute: null,
                                url: "business/credit/creManagement.html",
                                sequence: 2,
                                level: 4,
                                subMenu: null
                            }
                        ]
                    },
                    {
                        id: "302000",
                        createdby: null,
                        createdat: null,
                        lastchangedby: null,
                        lastchangedat: null,
                        deletetag: 0,
                        menuCode: "MRZSD",
                        menuName: "供应商产品目录监控",
                        parentId: "300000",
                        attribute: null,
                        url: "javascript:void0",
                        sequence: 2,
                        level: 3,
                        subMenu: [
                            {
                                id: "302010",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "XYSS",
                                menuName: "实时监控",
                                parentId: "302000",
                                attribute: null,
                                url: "business/suppliers/SupplierTime.html",
                                sequence: 1,
                                level: 4,
                                subMenu: null
                            }/*,
                        {
                            id: "3020020",
                            createdby: null,
                            createdat: null,
                            lastchangedby: null,
                            lastchangedat: null,
                            deletetag: 0,
                            menuCode: "XYFX",
                            menuName: "分析管理",
                            parentId: "302000",
                            attribute: null,
                            url: "business/suppliers/supManagement.html",
                            sequence: 2,
                            level: 4,
                            subMenu: null
                        }*/
                        ]
                    }
                ]
            },
            {
                id: "400000",
                createdby: null,
                createdat: null,
                lastchangedby: null,
                lastchangedat: null,
                deletetag: 0,
                menuCode: "GRSZ",
                menuName: "关键应用监控",
                parentId: "1",
                attribute: "dianbozhibov1213",
                url: "javascript:void0",
                sequence: 2,
                level: 2,
                subMenu: [
                    {
                        id: "401000",
                        createdby: null,
                        createdat: null,
                        lastchangedby: null,
                        lastchangedat: null,
                        deletetag: 0,
                        menuCode: "GRXX",
                        menuName: "实时监控",
                        parentId: "400000",
                        attribute: null,
                        url: "apply/realTime/keyBusy.html",
                        sequence: 1,
                        level: 3,
                        subMenu: null
                    },
                    {
                        id: "402000",
                        createdby: null,
                        createdat: null,
                        lastchangedby: null,
                        lastchangedat: null,
                        deletetag: 0,
                        menuCode: "MRZSD",
                        menuName: "分析管理",
                        parentId: "400000",
                        attribute: null,
                        url: "apply/analysis/keyManagement.html",
                        sequence: 2,
                        level: 3,
                        subMenu: null
                    }
                ]
            },
            {
                id: "500000",
                createdby: null,
                createdat: null,
                lastchangedby: null,
                lastchangedat: null,
                deletetag: 0,
                menuCode: "GRSZ",
                menuName: "配置",
                parentId: "1",
                attribute: "shezhi1",
                url: "javascript:void0",
                sequence: 2,
                level: 2,
                subMenu: [
                    {
                        id: "501000",
                        createdby: null,
                        createdat: null,
                        lastchangedby: null,
                        lastchangedat: null,
                        deletetag: 0,
                        menuCode: "GRXX",
                        menuName: "系统配置管理",
                        parentId: "500000",
                        attribute: null,
                        url: "javascript:void0",
                        sequence: 1,
                        level: 3,
                        subMenu: [
                            {
                                id: "501010",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "MRZSD",
                                menuName: "应用配置",
                                parentId: "501000",
                                attribute: null,
                                url: "configuration/apply/sysconfig.html",
                                sequence: 2,
                                level: 3,
                                subMenu: null
                            },
                            {
                                id: "501020",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "MRZSD",
                                menuName: "进程配置",
                                parentId: "501000",
                                attribute: null,
                                url: "configuration/apply/sysprocess.html",
                                sequence: 2,
                                level: 3,
                                subMenu: null
                            }
                        ]
                    },
                    {
                        id: "502000",
                        createdby: null,
                        createdat: null,
                        lastchangedby: null,
                        lastchangedat: null,
                        deletetag: 0,
                        menuCode: "MRZSD",
                        menuName: "基础数据管理",
                        parentId: "500000",
                        attribute: null,
                        url: "javascript:void0",
                        sequence: 2,
                        level: 3,
                        subMenu: [
                            {
                                id: "502010",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "MRZSD",
                                menuName: "用户维护",
                                parentId: "502000",
                                attribute: null,
                                url: "configuration/allConfiguration/users.html",
                                sequence: 2,
                                level: 3,
                                subMenu: null
                            },
                            {
                                id: "502020",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "MRZSD",
                                menuName: "角色维护",
                                parentId: "502000",
                                attribute: null,
                                url: "configuration/allConfiguration/roles.html",
                                sequence: 2,
                                level: 3,
                                subMenu: null
                            },
                            {
                                id: "502030",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "MRZSD",
                                menuName: "角色组维护",
                                parentId: "502000",
                                attribute: null,
                                url: "configuration/allConfiguration/positions.html",
                                sequence: 2,
                                level: 3,
                                subMenu: null
                            },
                            {
                                id: "502040",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "MRZSD",
                                menuName: "用户批导",
                                parentId: "502000",
                                attribute: null,
                                url: "configuration/allConfiguration/UserMulImport.html",
                                sequence: 2,
                                level: 3,
                                subMenu: null
                            },
                            {
                                id: "502050",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "MRZSD",
                                menuName: "通用角色批导",
                                parentId: "502000",
                                attribute: null,
                                url: "configuration/allConfiguration/localRoleMulImport.html",
                                sequence: 2,
                                level: 3,
                                subMenu: null
                            },
                            {
                                id: "502060",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "MRZSD",
                                menuName: "本地角色批导",
                                parentId: "502000",
                                attribute: null,
                                url: "configuration/allConfiguration/localRoleMulImport.html",
                                sequence: 2,
                                level: 3,
                                subMenu: null
                            },
                            {
                                id: "502070",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "MRZSD",
                                menuName: "岗位批导",
                                parentId: "502000",
                                attribute: null,
                                url: "configuration/allConfiguration/positionMulImport.html",
                                sequence: 2,
                                level: 3,
                                subMenu: null
                            },
                            {
                                id: "502080",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "MRZSD",
                                menuName: "用户分配岗位批导",
                                parentId: "502000",
                                attribute: null,
                                url: "configuration/allConfiguration/userAndPositionMulImport.html",
                                sequence: 2,
                                level: 3,
                                subMenu: null
                            },
                            {
                                id: "502090",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "MRZSD",
                                menuName: "用户与本地角色对应",
                                parentId: "502000",
                                attribute: null,
                                url: "configuration/allConfiguration/userAndLocalRoleMulImport.html",
                                sequence: 2,
                                level: 3,
                                subMenu: null
                            },
                            {
                                id: "502011",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "MRZSD",
                                menuName: "岗位与本地角色对应",
                                parentId: "502000",
                                attribute: null,
                                url: "configuration/allConfiguration/positionAndlocalRoleMulImport.html",
                                sequence: 2,
                                level: 3,
                                subMenu: null
                            },
                            {
                                id: "502012",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "MRZSD",
                                menuName: "字典管理",
                                parentId: "502000",
                                attribute: null,
                                url: "configuration/allConfiguration/goDict.html",
                                sequence: 2,
                                level: 3,
                                subMenu: null
                            },
                            {
                                id: "502013",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "MRZSD",
                                menuName: "菜单管理",
                                parentId: "502000",
                                attribute: null,
                                url: "configuration/allConfiguration/goMenu.html",
                                sequence: 2,
                                level: 3,
                                subMenu: null
                            }
                        ]
                    },
                    {
                        id: "503000",
                        createdby: null,
                        createdat: null,
                        lastchangedby: null,
                        lastchangedat: null,
                        deletetag: 0,
                        menuCode: "MRZSD",
                        menuName: "系统公告",
                        parentId: "500000",
                        attribute: null,
                        url: "javascript:void0",
                        sequence: 2,
                        level: 3,
                        subMenu: [
                            {
                                id: "503010",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "MRZSD",
                                menuName: "公告管理",
                                parentId: "503000",
                                attribute: null,
                                url: "configuration/announcement/advertisingMana.html",
                                sequence: 2,
                                level: 3,
                                subMenu: null
                            },
                            {
                                id: "503020",
                                createdby: null,
                                createdat: null,
                                lastchangedby: null,
                                lastchangedat: null,
                                deletetag: 0,
                                menuCode: "MRZSD",
                                menuName: "公告查看",
                                parentId: "503000",
                                attribute: null,
                                url: "configuration/announcement/advertisingView.html",
                                sequence: 2,
                                level: 3,
                                subMenu: null
                            }
                        ]
                    }
                ]
            }
        ]
    };
    function loginVolid(){

        $.ajax({
            url:"/monitoring/TreeController/getTreeToObject",
            type:"post",
            data:JSON.stringify(leftNavData),
            contentType : "application/json;charset=utf-8",   //发送至服务器的类型
            dataType : "json",                                  //预期服务器返回类型
            error:function(data){
            },
            success:function(data){

            }
        })
    }
</script>

<html>
<head>
    <title>文件上传</title>
</head>

<body>
<!-- 主要利用form的target属性 -->
<form action="${pageContext.request.contextPath}/monthlyController/uploadFileOss" enctype="multipart/form-data" method="post" target="target_frame" >

    选择文件：<input type="file" name="file"  multiple><br/>
    选择ID：<input type="text" name="id" ><br/>

    <input type="submit" value="提交">&nbsp;&nbsp;<span style="font-size: 13px">点击提交报告</span><br/>

    <select name="attCode">
        <option value="Monthly">月报</option>
        <option value="Other">第三方报告</option>
    </select>
    <br/>

    <input type="button" value="生成目录，千万别点！点了目录就爆炸 ！！！" onclick="loginVolid()"/>

    <!-- 此处iframe为隐藏,因此不会感觉到主页面刷新 -->
    <iframe name="target_frame" style="display:none"></iframe>

</form>
<form action="${pageContext.request.contextPath}/monthlyController/downFileOss" enctype="multipart/form-data" method="post" target="target_frame" >
    选择ID：<input type="text" name="id" ><br/>
    <input type="submit" value="提交">&nbsp;&nbsp;<span style="font-size: 13px">点击上传文件</span><br/>
    <select name="attCode">
        <option value="Monthly">月报</option>
        <option value="Other">第三方报告</option>
    </select>
    <br/>
    <input type="button" value="生成目录，千万别点！点了目录就爆炸 ！！！" onclick="loginVolid()"/>
    <!-- 此处iframe为隐藏,因此不会感觉到主页面刷新 -->
    <iframe name="target_frame" style="display:none"></iframe>
</form>

</body>
</html>
