/**
 * <pre>
 * Copyright:		Copyright(C) 2011-2012, ketayao.com
 * Date:			2013年7月29日
 * Author:			<a href="mailto:ketayao@gmail.com">ketayao</a>
 * Version          1.0.0
 * Description:		
 *
 * </pre>
 **/
package com.ketayao.action;

import java.util.List;

import org.apache.commons.lang3.math.NumberUtils;

import com.ketayao.fensy.mvc.WebContext;
import com.ketayao.pojo.Article;
import com.ketayao.util.PageInfo;

/** 
 * 	
 * @author 	<a href="mailto:ketayao@gmail.com">ketayao</a>
 * Version  1.0.0
 * @since   2013年7月29日 下午4:38:38 
 */
public class IndexAction extends AbstractAction {
	
	/**   
	 * @param rc
	 * @param p
	 * @return  
	 * @see com.ketayao.action.AbstractAction#process(com.ketayao.fensy.mvc.WebContext, java.lang.String[])  
	 */
	@Override
	protected String process(WebContext rc, String[] p) {
		PageInfo pageInfo = new PageInfo();
		if (p != null && p.length > 0) {
			pageInfo.setPageIndex(NumberUtils.toInt(p[0], 1));
		}
		
		List<Article> articles = Article.INSTANCE.findHome(pageInfo);
		
		rc.setRequestAttr("articles", articles);
		rc.setRequestAttr("pageInfo", pageInfo);
		
		// 有标题图片的日志
		PageInfo pageInfo2 = new PageInfo();
		pageInfo2.setPageSize(5);
		List<Article> imgArticles = Article.INSTANCE.findTitleImages(pageInfo2);
		rc.setRequestAttr("imgArticles", imgArticles);
		
		return READ;
	}

}
