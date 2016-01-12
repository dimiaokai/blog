<#compress>
<#import "WEB-INF/www/admin/lib/common.ftl" as com>
<#include "WEB-INF/www/admin/lib/user-nav.ftl"/>

<#--currentNav定义-->
<#assign currentNav>${bundle("site.userManage.list")}</#assign>

<#escape x as x?html>
<@com.page title=title sideNav=sideNav sideNavUrl=sideNavUrl parentNav=parentNav parentNavUrl=parentNavUrl currentNav=currentNav>

<script>
$(document).ready(function(){
	
	$(".delete").click(function(){
		return window.confirm("${bundle("form.isConfirm")}");
	});
	
});
</script>
<div id="main">
    	<table cellpadding="0" cellspacing="0">
			<tr style="font-weight:bold;">
				<td >${bundle("user.id")}</td>
				<td width="30">${bundle("user.username")}</td>
            	<td width="30">${bundle("user.nickname")}</td>
            	<td >${bundle("user.email")}</td>
            	<td width="30">${bundle("user.role")}</td>
            	<td width="30">${bundle("user.frozen")}</td>
            	<td align="center" width="100">${bundle("form.action")}</td>
        	</tr>
        	<#list users as user>
        	<tr>
				<td>${user.id}</td>
            	<td>${user.username}</td>
            	<td>${user.nickname}</td>
            	<td>${user.email}</td>
            	<td>${user.role}</td>
            	<td>${user.frozen}</td>
            	<td class="action">
            		<a target="_blank" href="#" class="view">${bundle("form.view")}</a>
            		<a href="#" class="edit">${bundle("form.edit")}</a>
            		<a href="#" class="delete">${bundle("form.delete")}</a>
            	</td>
        	</tr>
			</#list>
        </table>
        <br/>
        <#if users?size gt 0>
        	<div class="megas512">
        	<#noescape>
				${pageInfo.pageHtml}
        	</#noescape>
        	</div>
        </#if>	
        <br/><br/>
</div>
<!-- // #main -->

</@com.page>

</#escape>
</#compress>