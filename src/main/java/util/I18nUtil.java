package util;

import java.util.Locale;
import java.util.ResourceBundle;

import jakarta.servlet.http.HttpServletRequest;

/**
 * Utility class for internationalization support. Provides methods to get
 * localized messages based on user's language preference.
 */
public class I18nUtil {

    private static final String BUNDLE_NAME = "messages";
    private static final Locale DEFAULT_LOCALE = Locale.forLanguageTag("vi");

    /**
     * Language switching is removed. Always use fixed Vietnamese locale.
     */
    public static Locale getLocale(HttpServletRequest request) {
        return DEFAULT_LOCALE;
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

}
