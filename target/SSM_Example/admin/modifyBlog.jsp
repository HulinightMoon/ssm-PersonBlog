<%--
  Created by IntelliJ IDEA.
  User: wang_sir
  Date: 2019/11/30
  Time: 10:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>修改博客页面</title>
    <link rel="stylesheet" type="text/css" href="${ctx}/static/jquery-easyui-1.3.3/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/static/jquery-easyui-1.3.3/themes/icon.css">
    <script type="text/javascript" src="${ctx}/static/jquery-easyui-1.3.3/jquery.min.js"></script>
    <script type="text/javascript" src="${ctx}/static/jquery-easyui-1.3.3/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${ctx}/static/jquery-easyui-1.3.3/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" charset="gbk" src="${ctx}/static/newUeditor/ueditor.config.js"></script>
    <script type="text/javascript" charset="gbk" src="${ctx}/static/newUeditor/ueditor.all.js"></script>
    <!--建议手动加在语言，避免在ie下有时因为加载语言失败导致编辑器加载失败-->
    <!--这里加载的语言文件会覆盖你在配置项目里添加的语言类型，比如你在配置项目里配置的是英文，这里加载的中文，那最后就是中文-->
    <script type="text/javascript" charset="utf-8" src="${ctx}/static/newUeditor/lang/zh-cn/zh-cn.js"></script>
    <script type="text/javascript">
        // 发布博客
        function submitData() {
            //获取各个参数的值
            var title = $("#title").val();
            var blogTypeId=$("#blogTypeId").combobox("getValue");
            var content = UE.getEditor("editor").getContent();
            var keyWord = $("#keyWord").val();
            if (title == null || title == "") {
                alert("标题不能为空");
            } else if (blogTypeId == null || blogTypeId == "") {
                alert("请选择博客类型");
            }
            else if (content == null || content == "") {
                alert("请输入内容");
            } else if (keyWord == null || keyWord == "") {
                alert("请输入关键字");
            } else {
                $.post("${pageContext.request.contextPath}/admin/blog/save.do",
                    {
                        "id":${param.id},  //获取到从admin/blogManage.jsp页面中传的id值
                        "title": title,
                        "blogType.id": blogTypeId,
                        "content": content,
                        'summary':UE.getEditor('editor').getContentTxt().substr(0,155),
                        "keyWord": keyWord
                    }, function (result) {
                        if (result.success) {
                            alert("博客发布成功");
                            //清空数据
                            resetValue();
                        }else {
                            alert("博客发布失败")
                        }
                    },"json"
                );
            }
        }
        //重置参数
        function resetValue() {
            $("#title").val("");
            $("#blogTypeId").val("");
            UE.getEditor("editor").setContext("");
            $("#keyWord").val("");
        }
    </script>
</head>
<body style="margin: 10px">
<div id="p" class="easyui-panel" title="编写博客" style="padding: 10px">
    <table cellspacing="20px">
        <tr>
            <td width="80px">博客标题：</td>
            <td><input type="text" id="title" name="title" style="width: 400px;"/></td>
        </tr>
        <tr>
            <td>所属类别：</td>
            <td>
                <select class="easyui-combobox" style="width: 154px" id="blogTypeId" name="blogType.id" editable="false"
                        panelHeight="auto">
                    <option value="">请选择博客类别...</option>
                    <c:forEach var="blogType" items="${blogTypeCountList }">
                        <option value="${blogType.id }">${blogType.typeName }</option>
                    </c:forEach>
                </select>
            </td>
        </tr>
        <tr>
            <td valign="top">博客内容：</td>
            <td>
                <script id="editor" type="text/plain" style="width:100%;height:500px;"></script>
            </td>
        </tr>
        <tr>
            <td>关键字：</td>
            <td><input type="text" id="keyWord" name="keyWord" style="width: 400px;"/>&nbsp;(多个关键字中间用空格隔开)</td>
        </tr>
        <tr>
            <td></td>
            <td>
                <a href="javascript:submitData()" class="easyui-linkbutton"
                   data-options="iconCls:'icon-submit'">发布博客</a>
            </td>
        </tr>
    </table>
</div>

<script type="text/javascript">

    //实例化编辑器
    //建议使用工厂方法getEditor创建和引用编辑器实例，如果在某个闭包下引用该编辑器，直接调用UE.getEditor('editor')就能拿到相关的实例
    var ue = UE.getEditor("editor");
    // editor准备好之后才可以使用
    ue.addListener("ready", function () {
       //通过ajax请求获取数据设置到文本框中
        UE.ajax.request("${ctx}/admin/blog/findById.do",{
            method:"post",
            async:false,
            data:{"id":"${param.id}"},
            onsuccess:function (result) {
                result = eval("("+result.responseText+")");
                $("#title").val(result.title);
                $("#keyWord").val(result.keyWord);
                $("#blogTypeId").combobox("setValue",result.blogType.id);
                UE.getEditor("editor").setContent(result.content);
            }
        });
    });
</script>
</body>
</html>