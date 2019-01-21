<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../public/tag.jsp" %>
<%@ include file="../public/module.jsp" %>

<html lang="en">
<head>
    <title>在线出题系统</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">

    <link rel="stylesheet" type="text/css" href="${baseurl}/public/common/layui/css/layui.css" media="all">
    <link rel="stylesheet" type="text/css" href="${baseurl}/public/css/login.css" media="all">
</head>
<body>
<div class="larry-canvas" id="canvas"></div>
<div class="layui-layout layui-layout-login">
    <h1>
        <strong>在线出题系统</strong>
        <em> System</em>
    </h1>
    <div class="layui-user-icon larry-login">
        <input type="text" placeholder="账号/电话/邮箱" id="userName" required class="login_txtbx"/>
    </div>
    <div class="layui-pwd-icon larry-login">
        <input type="password" placeholder="密码" id="password" required class="login_txtbx"/>
    </div>
    <%--<div class="layui-val-icon larry-login">--%>
        <%--<div class="layui-code-box">--%>
            <%--<input type="text" id="code" name="code" placeholder="验证码" maxlength="4" class="login_txtbx">--%>
            <%--<img src="${baseurl}/public/images/verifyimg.png" alt="" class="verifyImg" id="verifyImg"--%>
                 <%--onclick="javascript:this.src='xxx'+Math.random();">--%>
        <%--</div>--%>
    <%--</div>--%>
    <div class="layui-submit larry-login">
        <button  onclick="login()"  class="submit_btn">立即登录</button>
    </div>

    <div class="layui-login-text">
    </div>
</div>
<script type="text/javascript" src="${baseurl}/public/common/js/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="${baseurl}/public/common/jsplugin/jparticle.jquery.js"></script>
<script type="text/javascript" src="${baseurl}/public/js/login.js"></script>

<script>
    function login() {
        let userName = $("#userName").val();
        let password = $("#password").val();
        $.ajax({
            url: "${baseurl}/login",
            data: {userName: userName, password: password},
            success: function (data) {
                if (data.result) {
                    //location.href = "${baseurl}/smxy/manual";
                    location.href = "${baseurl}/ictEnglish/index";
                    //location.href = "${baseurl}/smxy/test";
                } else {
                    layer.msg(data.msg);
                }
            }
        });
    }
    //为keyListener方法注册按键事件,设置回车事件
    document.onkeydown=keyListener;
    function keyListener(e){
        // 当按下回车键，执行我们的代码
        if(e.keyCode == 13){
            login();
        }
    }
</script>
</body>
</html>