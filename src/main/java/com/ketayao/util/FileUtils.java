/**
 * ketayao.com Inc.
 * Copyright (c) 2004-2016 All Rights Reserved.
 */
package com.ketayao.util;

/**
 * 
 * @author yaoqiang.yq
 * @version $Id: FileUtils.java, v 0.1 2016年1月12日 下午10:22:39 yaoqiang.yq Exp $
 */
public class FileUtils {

    public static String getUserHomePath(String path) {
        if (path != null && path.startsWith("~")) {
            path = path.replace("~", System.getProperties().get("user.home").toString());
        }

        return path;
    }
}
