<#compress>
<#import "WEB-INF/www/admin/lib/common.ftl" as com/>
<#include "WEB-INF/www/admin/lib/site-nav.ftl"/>

<#--currentNav定义-->
<#assign currentNav>${bundle("site.siteConfigManage.manage")}</#assign>

<#escape x as x?html>
<@com.page title=title sideNav=sideNav sideNavUrl=sideNavUrl parentNav=parentNav parentNavUrl=parentNavUrl currentNav=currentNav>
<#-- form验证 -->
<link rel="stylesheet" href="${rc.contextPath}/styles/formValidator.2.2.1/css/validationEngine.jquery.css" type="text/css"/>
<script src="${rc.contextPath}/styles/formValidator.2.2.1/js/languages/jquery.validationEngine-${(rc.locale)!'zh_CN'}.js" type="text/javascript" charset="utf-8"></script>
<script src="${rc.contextPath}/styles/formValidator.2.2.1/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
<script>
    jQuery(document).ready(function(){
        jQuery("#formID").validationEngine();
    });
    
</script>

<link rel="stylesheet" href="${rc.contextPath}/styles/editormd/css/editormd.css" />
<style>
.top-frame {
	z-index:999999;
}
</style>
<script src="${rc.contextPath}/styles/editormd/editormd.min.js"></script>
<#if rc.locale.language != 'zh'>
<script src="${rc.contextPath}/styles/editormd/languages/${(rc.locale.language)!'en'}.js"></script>
</#if>
<script type="text/javascript">
	var editor;

    $(function() {
        // You can custom Emoji's graphics files url path
        editormd.emoji     = {
            path  : "http://www.emoji-cheat-sheet.com/graphics/emojis/",
            ext   : ".png"
        };
    
        editor = editormd("description", {
            width   : "100%",
            height  : 640,
            syncScrolling : "single",
            path    : "${rc.contextPath}/styles/editormd/lib/",
            imageUpload : true,
            imageFormats : ["jpg", "jpeg", "gif", "png", "bmp"],
            imageUploadURL : "${rc.contextPath}/admin/file/upload?editor=editormd",
			toc : true,
			autoFocus : false,
			htmlDecode : true,
			watch : false,
            emoji : true,       // Support Github emoji, Twitter Emoji(Twemoji), fontAwesome, Editor.md logo emojis.
            onfullscreen : function() {
                $("#" + this.id).addClass("top-frame");
            },
            onfullscreenExit : function() {
                $("#" + this.id).removeClass("top-frame");
            }         
        });
    });
   
</script>

<div id="main">
		<h3 style="text-align:center;color:red;">
			<#if success??>${bundle("action.siteConfig.update")}</#if>
		</h3>
		<h3>
			<#noescape>${bundle("form.notice.required")}</#noescape>
		</h3>
		<form action="${rc.contextPath}/admin/siteConfig/u" class="jNice" method="POST" id="formID">
		<fieldset>
			<p>
				<label>${bundle("siteConfig.name")}<font color="red">*</font>:</label><input type="text" name="name" class="validate[required,maxSize[255]] text-long" value="${siteConfig.name}"  id="name"/>
			</p>
			<p>
				<label>${bundle("siteConfig.url")}<font color="red">*</font>(http://):</label><input id="website" name="url" class="text-long validate[required,maxSize[255],custom[url]]" value="${siteConfig.url}" />
			</p>
			<p>    
				<label>${bundle("siteConfig.about")}:</label><input id="about" name="about" class="text-long validate[optional,maxSize[255]]" value="${siteConfig.about}" />
			</p>
			<p>    
				<label>${bundle("siteConfig.icp")}:</label><input id="icp" name="icp" class="text-long validate[optional,maxSize[50]]" value="${siteConfig.icp}" />
			</p>
			<p>
				<label>${bundle("siteConfig.contactDescription")}<font color="red">*</font>:</label>
			    <div id="description">
			    	<textarea name="contactDescription" class="validate[optional,maxSize[1000]]" style="display:none;">${siteConfig.contactDescription}</textarea>
			    </div>					
			</p>
			<input type="submit" value='${bundle("form.save")}' />
		</fieldset>
        </form>
        <br/>	
        <br/><br/>
</div>
<!-- // #main -->

</@com.page>

</#escape>
</#compress>