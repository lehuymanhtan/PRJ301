package util;

import java.util.Locale;
import java.util.ResourceBundle;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;

/**
 * Utility class for internationalization support. Provides methods to get
 * localized messages based on user's language preference.
 */
public class I18nUtil {

    private static final String BUNDLE_NAME = "messages";
    private static final String LANGUAGE_SESSION_KEY = "lang";
    private static final String LANGUAGE_COOKIE_NAME = "userLang";
    private static final int COOKIE_MAX_AGE = 60 * 60 * 24 * 365; // 1 year
    private static final Locale DEFAULT_LOCALE = Locale.ENGLISH;

    private final HttpServletRequest request;

    public I18nUtil(HttpServletRequest request) {
        this.request = request;
    }

    public String get(String key) {
        return getMessage(request, key);
    }

    /**
     * Get the current locale based on priority: 1. User's database preference
     * (if logged in) 2. Session language 3. Cookie language 4. Browser
     * preference 5. Default (English)
     */
    public static Locale getLocale(HttpServletRequest request) {
        // Priority 1: Check logged-in user's preference
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user != null && user.getPreferredLanguage() != null) {
            return Locale.forLanguageTag(user.getPreferredLanguage());
        }

        // Priority 2: Check session
        String lang = (session != null) ? (String) session.getAttribute(LANGUAGE_SESSION_KEY) : null;
        if (lang != null && !lang.isEmpty()) {
            return Locale.forLanguageTag(lang);
        }

        // Priority 3: Check cookie
        String cookieLang = getLanguageFromCookie(request);
        if (cookieLang != null) {
            return Locale.forLanguageTag(cookieLang);
        }

        // Priority 4: Check browser preference
        Locale browserLocale = request.getLocale();
        if (browserLocale != null
                && (browserLocale.getLanguage().equals("vi") || browserLocale.getLanguage().equals("en"))) {
            return browserLocale;
        }

        // Priority 5: Default
        return DEFAULT_LOCALE;
    }

    /**
     * Get language from cookie.
     */
    private static String getLanguageFromCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (LANGUAGE_COOKIE_NAME.equals(cookie.getName())) {
                    String lang = cookie.getValue();
                    if ("vi".equals(lang) || "en".equals(lang)) {
                        return lang;
                    }
                }
            }
        }
        return null;
    }

    /**
     * Get the resource bundle for the current locale.
     */
    public static ResourceBundle getBundle(HttpServletRequest request) {
        Locale locale = getLocale(request);
        return ResourceBundle.getBundle(BUNDLE_NAME, locale);
    }

    /**
     * Get a localized message by key.
     */
    public static String getMessage(HttpServletRequest request, String key) {
        try {
            ResourceBundle bundle = getBundle(request);
            return bundle.getString(key);
        } catch (Exception e) {
            return key; // Return key if translation not found
        }
    }

    /**
     * Get a localized message with parameters.
     */
    public static String getMessage(HttpServletRequest request, String key, Object... params) {
        try {
            ResourceBundle bundle = getBundle(request);
            String message = bundle.getString(key);
            return String.format(message, params);
        } catch (Exception e) {
            return key;
        }
    }

    /**
     * Set the language preference in session, cookie, and optionally database.
     */
    public static void setLanguage(HttpServletRequest request, HttpServletResponse response, String language) {
        if ("vi".equals(language) || "en".equals(language)) {
            // Save to session
            request.getSession().setAttribute(LANGUAGE_SESSION_KEY, language);

            // Save to cookie
            Cookie cookie = new Cookie(LANGUAGE_COOKIE_NAME, language);
            cookie.setMaxAge(COOKIE_MAX_AGE);
            cookie.setPath("/");
            cookie.setHttpOnly(true);
            response.addCookie(cookie);
        }
    }

    /**
     * Set the language preference (legacy method for backward compatibility).
     */
    public static void setLanguage(HttpServletRequest request, String language) {
        if ("vi".equals(language) || "en".equals(language)) {
            request.getSession().setAttribute(LANGUAGE_SESSION_KEY, language);
        }
    }

    /**
     * Get current language code.
     */
    public static String getCurrentLanguage(HttpServletRequest request) {
        Locale locale = getLocale(request);
        return locale.getLanguage();
    }
}
