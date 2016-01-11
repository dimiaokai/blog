<#compress>
<#import "WEB-INF/www/admin/lib/common.ftl" as com>
<#include "WEB-INF/www/admin/lib/content-nav.ftl"/>
<#--currentNav定义-->
<#assign currentNav>${bundle("site.articleManage.update")}</#assign>
</#compress>
<#escape x as x?html>
<@com.page title=title sideNav=sideNav sideNavUrl=sideNavUrl parentNav=parentNav parentNavUrl=parentNavUrl currentNav=currentNav>
<#-- autocomplete -->
<script type='text/javascript' src='${rc.contextPath}/styles/jquery-autocomplete/jquery.autocomplete.pack.js'></script>
<link rel="stylesheet" type="text/css" href="${rc.contextPath}/styles/jquery-autocomplete/jquery.autocomplete.css" />

<#-- form验证 -->
<link rel="stylesheet" href="${rc.contextPath}/styles/formValidator.2.2.1/css/validationEngine.jquery.css" type="text/css"/>
<script src="${rc.contextPath}/styles/formValidator.2.2.1/js/languages/jquery.validationEngine-${(rc.locale)!'zh_CN'}.js" type="text/javascript" charset="utf-8"></script>
<script src="${rc.contextPath}/styles/formValidator.2.2.1/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
<script>
    jQuery(document).ready(function(){
        jQuery("#formID").validationEngine();
        
        $("#tags").autocomplete(${tags}, {
			width: 200,
			multiple: true,
			matchContains: true
		});
		
		$("#switchEditor").click(function(){
			if(!confirm("切换编辑器将会丢失未保存的内容，确定离开吗？")){
				return;
			}
			var edit;
			<#if editor != 'editormd'>
			edit = 'editormd';
			<#else>
			edit = 'kindeditor';
			</#if>
			var url = window.location.href;
			if (url.indexOf('?') > -1) {
				if (url.indexOf('?editor') > -1) {
					url = url.substring(0, url.indexOf('?editor'));
					url += '?editor=' + edit;
				} else if (url.indexOf('&editor') > -1) {
					url = url.substring(0, url.indexOf('&editor'));
					url += '&editor=' + edit;
				} else {
					url += '&editor=' + edit;
				}
			} else {
				url += '?editor=' + edit;
			}
			window.location.href=url;
		});		
    });
    
</script>
<#if editor == 'editormd'>
<link rel="stylesheet" href="${rc.contextPath}/styles/editormd/css/editormd.css" />
<style>
.top-frame {
	z-index:999999;
}
</style>
<script src="${rc.contextPath}/styles/editormd/editormd.min.js"></script>
<script type="text/javascript">
	var editor;
	var editorSummary;

    $(function() {
        // You can custom Emoji's graphics files url path
        editormd.emoji     = {
            path  : "http://www.emoji-cheat-sheet.com/graphics/emojis/",
            ext   : ".png"
        };
    
        editor = editormd("content", {
            width   : "100%",
            height  : 640,
            syncScrolling : "single",
            path    : "${rc.contextPath}/styles/editormd/lib/",
            imageUpload : true,
            imageFormats : ["jpg", "jpeg", "gif", "png", "bmp"],
            imageUploadURL : "${rc.contextPath}/admin/file/upload?editor=editormd",
			toc : true,
            emoji : true,       // Support Github emoji, Twitter Emoji(Twemoji), fontAwesome, Editor.md logo emojis.
            onfullscreen : function() {
                $("#" + this.id).addClass("top-frame");
            },
            onfullscreenExit : function() {
                $("#" + this.id).removeClass("top-frame");
            }         
        });
        
		editorSummary = editormd("summary", {
            width   : "100%",
            height  : 300,
            syncScrolling : "single",
            path    : "${rc.contextPath}/styles/editormd/lib/",
            imageUpload : true,
            imageFormats : ["jpg", "jpeg", "gif", "png", "bmp"],
            imageUploadURL : "${rc.contextPath}/admin/file/upload?editor=editormd",
            onfullscreen : function() {
                $("#" + this.id).addClass("top-frame");
            },
            onfullscreenExit : function() {
                $("#" + this.id).removeClass("top-frame");
            }
        });
    });
   
</script>
<#else>
<script charset="utf-8" src="${rc.contextPath}/styles/kindeditor-4.1.10/kindeditor-min.js"></script>
<link rel="stylesheet" type="text/css" href="${rc.contextPath}/styles/kindeditor-4.1.10/shcodeandquote.css" />
<script>
	var editor;
	KindEditor.ready(function(K) {
		editor = K.create('textarea[id="content"]', {
			langType : '<#if rc.locale?? && rc.locale != 'zh_CN'>en<#else>${(rc.locale)!'zh_CN'}</#if>',
			uploadJson : '${rc.contextPath}/admin/file/upload',
			cssPath : ['${rc.contextPath}/styles/kindeditor-4.1.10/plugins/shcode/shcode.css'],
			allowFileManager : false,
			newlineTag : 'br',
			items : [
					'source', '|', 'undo', 'redo', '|', 'preview', 'print', 'template', 'shcode', 'quote', 'cut', 'copy', 'paste',
					'plainpaste', 'wordpaste', '|', 'justifyleft', 'justifycenter', 'justifyright',
					'justifyfull', 'insertorderedlist', 'insertunorderedlist', 'indent', 'outdent', 'subscript',
					'superscript', 'clearhtml', 'quickformat', 'selectall',
					'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold',
					'italic', 'underline', 'strikethrough', 'lineheight', 'removeformat', '|', 'image', 'multiimage',
					'flash', 'media', 'table', 'hr', 'emoticons', 'baidumap', 'pagebreak',
					'anchor', 'link', 'unlink', '/', 'fullscreen', 'about'
				],
			filterMode : false,			
			afterChange : function() {
				jQuery('#content').validationEngine('hide');
			}
		});
	});
	
	var editorSummary;
	
	KindEditor.ready(function(K) {
		editorSummary = K.create('textarea[id="summary"]', {
			langType : '<#if rc.locale?? && rc.locale != 'zh_CN'>en<#else>${(rc.locale)!'zh_CN'}</#if>',
			uploadJson : '${rc.contextPath}/admin/file/upload',
			cssPath : ['${rc.contextPath}/styles/kindeditor-4.1.10/plugins/shcode/shcode.css'],
			allowFileManager : false,
			newlineTag : 'br',
		    items : ['bold', 'italic', 'underline', 'strikethrough', 'removeformat','|','insertorderedlist', 'insertunorderedlist', 
				 'forecolor', 'hilitecolor', 'fontname', 'fontsize',  '|', 'link', 'unlink', 'emoticons', 
				 'shcode', 'image', 'flash', 'quote', '|', 'fullscreen', 'source','about'],
			filterMode : false,
			afterChange : function() {
				jQuery('#summary').validationEngine('hide');
			}
		});
	});
	
	jQuery(document).ready(function(){
        $("#actionArticle").click(function(){
       		if(editor.count('text')==0){
				jQuery('#content').validationEngine('showPrompt', '${bundle("form.notice.column.required")}', 'error', true);
				return false;
			} 
			return true;
        });
        
        jQuery("#back").click(function(){
        	var url = "${rc.contextPath}/admin/article/read";
        	url = url + "?categoryId=${categoryId!''}&pageIndex=${pageIndex}";
    		window.location.href=url;
    	});
    });
</script>
</#if>

<script type="text/javascript" src="${rc.contextPath}/styles/AjaxFileUploaderV2.1/ajaxfileupload.js"></script>
<script type="text/javascript">
function ajaxFileUpload(){
	$("#loading").ajaxStart(function(){
		$(this).show();
	}).ajaxComplete(function(){
		$(this).hide();
	});

	var arr = [];
	arr[0] = 'imgFile';
	$.ajaxFileUpload({
		url:'${rc.contextPath}/admin/file/upload',
		secureuri:false,
		fileElementId:arr,
		dataType: 'json',
		data:{},
		success: function (data, status) {
			if(typeof(data.error) != 'undefined'){
				if(data.error == 1){
					alert(data.message);
				} else {
					$("#showUrl").attr("src", data.url);
					$("#showUrl").show();
					$("#delImgBtn").show();
					$("#imgUrl").val(data.url);
				}
			}
		},
		error: function (data, status, e){
			alert(e);
		}
	});
	
	return false;
}

function deleteImg(){
	$("#imgUrl").val("");
	$("#showUrl").hide();
	$("#delImgBtn").hide();
}
</script>

<div id="main">
	<form id="fileuploadForm" action="${rc.contextPath}/admin/attach/upload?id=${article.id}&categoryId=${categoryId}&pageIndex=${pageIndex}" class="jNice" method="POST" enctype="multipart/form-data">
		<h3 class="lovej-action">
			<#if success??>${bundle("action.article.update")}</#if>
			<#if RequestParameters.message??>${RequestParameters.message}</#if>
		</h3>
		<fieldset>	
			<p>
		    <label>${bundle("attach.description")}:<input type="file" name="file" ></label><input type="text" name="description" class="text-long">
		    <input type="submit" value='${bundle("form.upload")}' style="float:left;"/>
		    <p>
		</fieldset>
	</form>
	<table cellpadding="0" cellspacing="0">
	<tr style="font-weight:bold;">
		<td>${bundle("attach.url")}</td>
		<td>${bundle("attach.description")}</td>
		<td>${bundle("attach.download")}</td>
		<td align="center">${bundle("form.action")}</td>
	</tr>
	<#list attaches as a>
	<tr>
		<td>${a.url}</td>
		<td>${a.description}</td>
		<td>${a.download}</td>
		<td class="action">
			<a href="${rc.contextPath}/download?file=${a.url}" class="view" target="_blank">${bundle("form.download")}</a>
			<a href="${rc.contextPath}/admin/attach/delete/${a.id}?id=${a.articleId}&categoryId=${categoryId}&pageIndex=${pageIndex}" class="delete">${bundle("form.delete")}</a>
		</td>
	</tr>
	</#list>
	</table>
	</br>
	<form action="${rc.contextPath}/admin/article/update" class="jNice" method="POST" id="formID">
		<h3>
			<#noescape>${bundle("form.notice.required")}</#noescape>
			<div class="choise" style="float:right;color:red;"><input id="top" type="checkbox" name="top" <#if article.topTime??>checked="checked"</#if>/>${bundle("article.top")}</div>
		</h3>
		<fieldset>
			<p>
				<label>${bundle("article.title")}<font color="red">*</font>:</label><input type="text" name="title" class="validate[required,maxSize[255]] text-long"  id="title" value="${article.title}"/>
			</p>
			<p>
				<label>${bundle("article.imgUrl")}:<img id="loading" src="${rc.contextPath}/styles/AjaxFileUploaderV2.1/loading.gif" style="display:none;"></label>
				<input id="imgFile" type="file" size="45" name="imgFile" class="text-long">
				<input type="button" value="上传" onclick="return ajaxFileUpload();">
			</p>
			<p>
				<#if (article.imgUrl)?exists || (article.imgUrl) != ''>
					<img id="showUrl" src="${article.imgUrl}" width="666">
					<input id="delImgBtn" type="button" value="删除" onclick="deleteImg();">
				<#else>
					<img id="showUrl" src="" style="display:none;">
					<input id="delImgBtn" type="button" value="删除" onclick="deleteImg();" style="display:none;">
				</#if>
				<input type="hidden" id="imgUrl" name="imgUrl" value="${article.imgUrl}">
			</p>			
			<p>
				<label>${bundle("article.keywords")}:</label><input type="text" name="keywords" id="keywords" class="validate[optional,maxSize[255]] text-long" style="width:640px;" value="${article.keywords}"/>
			</p>
			<p>
				<label>${bundle("article.category")}<font color="red">*</font>:</label>
			</p>
			<div class="lovej-choise">
				<#if parents?size==0>
					<font color="red">--------${bundle("form.notice.article.category")}</font>
				<#else>
					<#list parents as p>
						<div class="choise-group">
						<div class="choise"><input id="p${p.id}" <#if article.categoryId == p.id>checked="checked"</#if> type="checkbox" name="categoryId" value='${p.id}' class='validate[required,maxCheckbox[1]]'/>${p.name}(${p.type})</div>
						<#list p.children as c>
							<#if (c_index+1)%4 == 0>
								<div class="choise"></div>
							</#if>
							<div class="choise"><input id="c${c.id}" <#if article.categoryId == c.id>checked="checked"</#if> type="checkbox" name="categoryId" value='${c.id}' class='validate[required,maxCheckbox[1]]'/>${c.name}(${c.type})</div>
						</#list>
						</div>
					</#list>	
				</#if>
			</div>
			<p>
				<label>${bundle("article.content")}<font color="red">*</font>:
				<input type="button" value="切换编辑器" id="switchEditor">
				</label>
				<input name="editor" type="hidden" value="${editor}">
				<#if editor == 'editormd'>
				    <div id="content">
				        <textarea name="content" style="display:none;">${article.content}</textarea>
				    </div>		
				<#else>
					<textarea id="content" name="content" style="width:655px;height:500px;" >${article.content}</textarea>
				</#if>					
			</p>
			<p>
				<label>${bundle("article.tag")}:</label><input type="text" name="tags" id="tags" class="validate[optional,maxSize[255]] text-long" style="width:640px;" value="${arTags}"/>
			</p>			
			<p>
				<label>${bundle("article.summary")}:</label>
				<#if editor == 'editormd'>
				    <div id="summary">
				        <textarea name="summary" class="validate[optional,maxSize[1000]]" style="display:none;">${article.summary}</textarea>
				    </div>		
				<#else>
					<textarea style="width:655px;height:300px;" name="summary" id="summary" class="validate[optional,maxSize[1000]]">${article.summary}</textarea>
				</#if>				
			</p>
			<p>
				<label>${bundle("article.status")}<font color="red">*</font>:</label>
			</p>
			<div class="lovej-choise" >
				<div class="choise"><input id="status1" type="checkbox" <#if article.status == 'publish'>checked="checked"</#if> name="status" value='publish' class='validate[required,maxCheckbox[1]]'/>${bundle("article.status.publish")}</div>
				<div class="choise"><input id="status2" type="checkbox" <#if article.status == 'private'>checked="checked"</#if> name="status" value='private' class='validate[required,maxCheckbox[1]]'/>${bundle("article.status.private")}</div>
				<div class="choise"><input id="status3" type="checkbox" <#if article.status == 'draft'>checked="checked"</#if> name="status" value='draft' class='validate[required,maxCheckbox[1]]'/>${bundle("article.status.draft")}</div>
			</div>
			<input name="categoryId" value="${categoryId}" type="hidden"/>
			<input name="pageIndex" value="${pageIndex}" type="hidden"/>
			
			<input name="id" value="${article.id}" type="hidden"/>
			<input id="actionArticle" type="submit" value='${bundle("form.save")}' />&nbsp;&nbsp;&nbsp;&nbsp;
			<input id="back" type="button" value='${bundle("form.back")}' />

		</fieldset>
	</form>
</div>
<#-- // #main -->
</@com.page>
</#escape>