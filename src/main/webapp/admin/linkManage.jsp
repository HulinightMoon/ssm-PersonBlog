<%--
  Created by IntelliJ IDEA.
  User: wang_sir
  Date: 2019/12/7
  Time: 16:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set value="${pageContext.request.contextPath}" var="ctx"/>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>友情链接管理页面</title>
    <link rel="stylesheet" type="text/css" href="${ctx}/static/jquery-easyui-1.3.3/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/static/jquery-easyui-1.3.3/themes/icon.css">
    <script type="text/javascript" src="${ctx}/static/jquery-easyui-1.3.3/jquery.min.js"></script>
    <script type="text/javascript" src="${ctx}/static/jquery-easyui-1.3.3/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${ctx}/static/jquery-easyui-1.3.3/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript">
        /**
         * 添加友情链接信息
         */
        function openLinkAddDialog(){
            $("#dlg").dialog("open").dialog("setTitle","添加友情链接信息");
            url="${pageContext.request.contextPath}/admin/link/save.do";
        }

        /**
         * 修改友情链接信息
         */
        function openLinkModifyDialog() {
           var selections = $("#dg").datagrid('getSelections'); //选择到所要修改的信息id
            if(selections.length==0){
                $.messager.alert("系统提示","请选择要修改的链接");
                return;
            }
            var row=selections[0];
            $("#dlg").dialog("open").dialog("setTitle","编辑链接信息");
            $("#fm").form("load",row);
            url="${ctx}/admin/link/save.do?id="+row.id;
        }

        /**
         * 保存链接信息
         */
        function saveLink(){
            $("#fm").form("submit",{
                url:url,
                onSubmit:function(){
                    return $(this).form("validate");
                },
                success:function (result) {
                    var result=eval('('+result+')');
                    if(result.success){
                        $.messager.alert("系统提示","保存成功！");
                        resetValue();
                        $("#dlg").dialog("close");
                        $("#dg").datagrid("reload");
                    }else{
                        $.messager.alert("系统提示","保存失败！");
                        return;
                    }
                }
            });
        }
        /**
         * 删除友情链接
         */
        function deleteLink() {
            var selections = $("#dg").datagrid("getSelections");
            if (selections.length==0){
                $.messager.alert("系统提示","请选择要删除的链接");
                return;
            }
            var strId=[];
            for (var i=0;i<selections.length;i++){
                strId.push(selections[i].id);
            }
            var ids=strId.join(",");
            $.messager.confirm("系统提示","您确定要删除这<font color=red>"+selections.length+"</font>条数据吗？",function (r) {
                if (r){
                    $.post("${ctx}/admin/link/delete.do",{ids:ids},function (result) {
                        if (result.success){
                            $.messager.alert("系统提示","数据已成功删除！");
                            $("#dg").datagrid("reload");
                        }else {
                            $.messager.alert("系统提示","数据删除失败！");
                        }
                    },"json");
                }
            });

        }
        /**重置值*/
        function resetValue(){
            $("#linkName").val("");
            $("#linkUrl").val("");
            $("#orderNo").val("");
        }
        /**清除值*/
        function closeLinkDialog(){
            $("#dlg").dialog("close");
            resetValue();
        }
    </script>
</head>
<body style="margin: 1px">
<table id="dg" title="友情链接管理" class="easyui-datagrid"
       fitColumns="true" pagination="true" rownumbers="true"
       url="${ctx}/admin/link/list.do" fit="true" toolbar="#tb">
    <thead>
    <tr>
        <th field="cb" checkbox="true" align="center"></th>
        <th field="id" width="20" align="center">编号</th>
        <th field="linkName" width="200" align="center">友情链接名称</th>
        <th field="linkUrl" width="200" align="center">友情链接地址</th>
        <th field="orderNo" width="100" align="center">排序序号</th>
    </tr>
    </thead>
</table>
<div id="tb">
    <div>
        <a href="javascript:openLinkAddDialog()" class="easyui-linkbutton" iconCls="icon-add" plain="true">添加</a>
        <a href="javascript:openLinkModifyDialog()" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
        <a href="javascript:deleteLink()" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
    </div>
</div>
<div id="dlg" class="easyui-dialog" style="width:500px;height:200px;padding: 10px 20px"
     closed="true" buttons="#dlg-buttons">

    <form id="fm" method="post">
        <table cellspacing="8px">
            <tr>
                <td>友情链接名称：</td>
                <td><input type="text" id="linkName" name="linkName" class="easyui-validatebox" required="true"/></td>
            </tr>
            <tr>
                <td>友情链接地址：</td>
                <td><input type="text" id="linkUrl" name="linkUrl" class="easyui-validatebox" validtype="url" required="true" style="width: 250px"/></td>
            </tr>
            <tr>
                <td>友情链接排序：</td>
                <td><input type="text" id="orderNo" name="orderNo" class="easyui-numberbox" required="true" style="width: 60px"/>&nbsp;(友情链接根据排序序号从小到大排序)</td>
            </tr>
        </table>
    </form>
</div>

<div id="dlg-buttons">
    <a href="javascript:saveLink()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
    <a href="javascript:closeLinkDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
</div>
</body>
</html>