package filter;

import java.io.IOException;
import java.util.ResourceBundle;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.I18nUtil;

/**
 * Filter that sets the locale and resource bundle for each request. Makes i18n
 * resources available throughout the application.
 */
@WebFilter(urlPatterns = {"/*"})
public class LocaleFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        if (request instanceof HttpServletRequest && response instanceof HttpServletResponse) {
            HttpServletRequest httpRequest = (HttpServletRequest) request;
            HttpServletResponse httpResponse = (HttpServletResponse) response;

            // Check if language switch was requested
            String langParam = httpRequest.getParameter("lang");
            if (langParam != null && !langParam.isEmpty()) {
                I18nUtil.setLanguage(httpRequest, httpResponse, langParam);
            }

            // Set locale and bundle as request attributes for JSP access
            ResourceBundle bundle = I18nUtil.getBundle(httpRequest);
            String currentLang = I18nUtil.getCurrentLanguage(httpRequest);

            request.setAttribute("bundle", bundle);
            request.setAttribute("currentLang", currentLang);
            request.setAttribute("i18n", new I18nUtil(httpRequest));
        }

        chain.doFilter(request, response);
    }

    /**
     * Helper class to make i18n easier in JSP using EL. Usage in JSP:
     * ${i18n.get('key')}
     */
    public static class I18nHelper {

        private final HttpServletRequest request;

        public I18nHelper(HttpServletRequest request) {
            this.request = request;
        }

        public String get(String key) {
            return I18nUtil.getMessage(request, key);
        }

        public String format(String key, Object... params) {
            return I18nUtil.getMessage(request, key, params);
        }
    }
}
