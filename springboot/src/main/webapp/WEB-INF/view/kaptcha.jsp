<%--
  Created by IntelliJ IDEA.
  User: shili
  Date: 2018/9/14
  Time: 12:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head lang="en">
    <meta charset="UTF-8" />
    <title>hello</title>
</head>
<body>
<%--<h1 th:text="${info}" />--%>
<%=request.getAttribute("info")%>

<div>
    <!-- <img alt="这是图片" src="/img/001.png"/> -->
    <img alt="验证码" onclick = "this.src='/defaultKaptcha?d='+new Date()*1" src="/defaultKaptcha" />
</div>
<form action="/imgvrifyControllerDefaultKaptcha">
    <input type="text" name="vrifyCode" />
    <input type="submit" value="提交"></input>
</form>
</body>
</html>
