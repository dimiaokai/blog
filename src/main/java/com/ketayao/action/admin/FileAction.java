package com.ketayao.action.admin;

import java.io.File;
import java.io.IOException;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ketayao.fensy.mvc.WebContext;
import com.ketayao.fensy.webutil.StorageService;
import com.ketayao.system.Constants;
import com.ketayao.util.QiNiuUtils;

public class FileAction {
    /** logger */
    private static final Logger LOGGER = LoggerFactory.getLogger(FileAction.class);

    public void upload(WebContext rc) throws IOException {
        boolean result = true;
        boolean isEditormd = StringUtils.equals(Constants.EDITOR_EDITORMD, rc.getParam("editor"));
        String url = null;
        try {
            File imgFile = null;
            if (isEditormd) {
                imgFile = rc.getImage("editormd-image-file");
            } else {
                imgFile = rc.getImage("imgFile");
            }

            if (imgFile.length() > WebContext.getMaxSize()) {
                rc.printJson(new String[] { "error", "message" },
                    new Object[] { Integer.valueOf(1), "File is too large" });
                return;
            }

            if (QiNiuUtils.isUse()) {
                url = QiNiuUtils.genKey(imgFile.getName());
                result = QiNiuUtils.upload(url, imgFile);
                url = rc.getContextPath() + "/file/images?p=" + url;
            } else {
                StorageService ss = StorageService.IMAGE;
                String path = ss.save(imgFile);
                url = rc.getContextPath() + ss.getReadPath() + path;
            }

        } catch (Exception e) {
            LOGGER.error("图片上传失败...", e);
            result = false;
        }

        if (result) {
            if (isEditormd) {
                rc.printJson(new String[] { "success", "url" }, new Object[] { 1, url });
            } else {
                rc.printJson(new String[] { "error", "url" }, new Object[] { 0, url });
            }
        } else {
            if (isEditormd) {
                rc.printJson(new String[] { "success", "message" }, new Object[] { 0, "图片上传出错！" });
            } else {
                rc.printJson(new String[] { "error", "message" },
                    new Object[] { Integer.valueOf(1), "图片上传出错！" });
            }
        }

    }
}
