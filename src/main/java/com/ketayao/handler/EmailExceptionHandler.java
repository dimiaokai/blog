/**
 * <pre>
 * Date:            2013年9月7日
 * Author:          <a href="mailto:ketayao@gmail.com">ketayao</a>
 * Description:
 * </pre>
 **/

package com.ketayao.handler;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateFormatUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ketayao.fensy.handler.SimpleExceptionHandler;
import com.ketayao.fensy.mvc.WebContext;
import com.ketayao.fensy.webutil.RequestUtils;
import com.ketayao.system.SystemConfig;
import com.ketayao.util.EmailUtils;

/**
 * 
 * @author <a href="mailto:ketayao@gmail.com">ketayao</a>
 * @since 2013年9月7日 下午6:27:05
 */

public class EmailExceptionHandler extends SimpleExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(EmailExceptionHandler.class);

    /**
     * 报告错误信息
     * 
     * @param req
     * @param excp
     */
    public static void reportError(HttpServletRequest req, Throwable excp) {
        boolean is_localhost = (req != null) ? "127.0.0.1".equals(RequestUtils.getRemoteAddr(req))
            : false;
        Throwable t = excp;
        if (t == null)
            t = _getException(req);
        if (t == null)
            return;

        if (!is_localhost)
            // 发送电子邮件通知
            try {
                String email = SystemConfig.getConfig().get("blog.exception.email.to");
                if (org.apache.commons.lang3.StringUtils.isBlank(email)) {
                    return;
                }

                String title = "错误" + t.getClass().getSimpleName();
                String content = getErrorHtml(req, t);
                // 发送邮件到指定邮箱
                EmailUtils.sendHtmlMail(Arrays.asList(StringUtils.split(email, ",")), title,
                    content);
            } catch (Exception e) {
                log.error("Failed to send error report.", e);
            }
    }

    /**
     * 格式化错误信息
     * 
     * @param req
     * @param t
     *            错误信息
     * @param site
     *            出错的个人空间
     * @return <h2>Request Headers</h2>
     */
    @SuppressWarnings("rawtypes")
    public static String getErrorHtml(HttpServletRequest req, Throwable t) {
        StringBuilder html = new StringBuilder();
        if (req != null) {
            html.append("<h2>Request Headers</h2><table>");
            html.append("<tr><th>Request URL</th><td>");
            html.append(req.getRequestURL().toString());
            if (req.getQueryString() != null) {
                html.append('?');
                html.append(req.getQueryString());
            }
            html.append("</td></tr>");
            html.append("<tr><th>Remote Addr</th><td>");
            html.append(RequestUtils.getRemoteAddr(req));
            html.append("</td></tr>");
            html.append("<tr><th>Request Method</th><td>");
            html.append(req.getMethod());
            html.append("</td></tr>");
            html.append("<tr><th>CharacterEncoding</th><td>");
            html.append(req.getCharacterEncoding());
            html.append("</td></tr>");
            html.append("<tr><th>Request Locale</th><td>");
            html.append(req.getLocale());
            html.append("</td></tr>");
            html.append("<tr><th>Content Type</th><td>");
            html.append(req.getContentType());
            html.append("</td></tr>");
            Enumeration headers = req.getHeaderNames();
            while (headers.hasMoreElements()) {
                String key = (String) headers.nextElement();
                html.append("<tr><th>");
                html.append(key);
                html.append("</th><td>");
                html.append(req.getHeader(key));
                html.append("</td></tr>");
            }
            html.append("</table><h2>Request Parameters</h2><table>");
            Enumeration params = req.getParameterNames();
            while (params.hasMoreElements()) {
                String key = (String) params.nextElement();
                html.append("<tr><th>");
                html.append(key);
                html.append("</th><td>");
                html.append(req.getParameter(key));
                html.append("</td></tr>");
            }
            html.append("</table>");
        }
        html.append("<h2>");
        html.append(t.getClass().getName());
        html.append('(');
        html.append(DateFormatUtils.format(System.currentTimeMillis(), "yyyy-MM-dd HH:mm:ss"));
        html.append(")</h2><pre>");
        try {
            html.append(_exception(t));
        } catch (IOException ex) {
        }
        html.append("</pre>");

        html.append("<h2>System Properties</h2><table>");
        Set props = System.getProperties().keySet();
        for (Object prop : props) {
            html.append("<tr><th>");
            html.append(prop);
            html.append("</th><td>");
            html.append(System.getProperty((String) prop));
            html.append("</td></tr>");
        }
        html.append("</table>");
        return html.toString();
    }

    /**
     * 将当前上下文发生的异常转为字符串
     * 
     * @return
     * @throws IOException
     */
    private static Throwable _getException(HttpServletRequest req) {
        if (req == null)
            return null;
        Throwable t = (Throwable) req.getAttribute("javax.servlet.jsp.jspException");
        if (t == null) {
            // Tomcat的错误处理方式
            t = (Throwable) req.getAttribute("javax.servlet.error.exception");
        }
        return t;
    }

    /**
     * 将异常信息转化成字符串
     * 
     * @param t
     * @return
     * @throws IOException
     */
    private static String _exception(Throwable t) throws IOException {
        if (t == null)
            return null;
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        try {
            t.printStackTrace(new PrintStream(baos));
        } finally {
            baos.close();
        }
        return baos.toString();
    }

    /**
     * @param rc
     * @param exception
     * @return
     * @see com.ketayao.fensy.handler.ExceptionHandler#handle(com.ketayao.fensy.mvc.WebContext,
     *      java.lang.Exception)
     */
    @Override
    public String handle(final WebContext rc, final Exception exception) {
        String view = super.handle(rc, exception);

        if (StringUtils.equals(SystemConfig.getConfig().get("blog.exception.email.switch"),
            "true")) {
            new Thread(new Runnable() {

                @Override
                public void run() {
                    reportError(rc.getRequest(), exception);
                }
            }).start();
        }

        return view;
    }

}
