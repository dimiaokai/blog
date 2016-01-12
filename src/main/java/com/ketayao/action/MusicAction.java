
package com.ketayao.action;

import java.io.FileInputStream;
import java.io.InputStream;

import javax.servlet.ServletOutputStream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ketayao.action.admin.TrackAction;
import com.ketayao.fensy.mvc.WebContext;
import com.ketayao.fensy.util.IOUtils;

/**
 * 
 * @author yaoqiang.yq
 * @version $Id: MusicAction.java, v 0.1 2016年1月12日 下午9:25:59 yaoqiang.yq Exp $
 */
public class MusicAction {
    /** logger */
    private static final Logger LOGGER = LoggerFactory.getLogger(MusicAction.class);

    public void index(WebContext rc, String[] p) throws Exception {
        String playlist = TrackAction.getPlaylist(rc);

        ServletOutputStream outputStream = rc.getResponse().getOutputStream();
        InputStream input = null;
        try {
            input = new FileInputStream(playlist);

            IOUtils.copy(input, outputStream);
            outputStream.flush();
        } catch (Exception e) {
            LOGGER.error("获取dewplayer出错：" + playlist, e);
        } finally {
            IOUtils.closeQuietly(input);
            IOUtils.closeQuietly(outputStream);
        }

    }

}
