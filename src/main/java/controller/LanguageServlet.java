package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.User;
import services.UserService;
import util.I18nUtil;
import java.io.IOException;

/**
 * Handles language switching. Accepts lang parameter (vi or en) and redirects
 * back to the referring page. Also updates user's language preference in
 * database if logged in.
 */
@WebServlet(urlPatterns = {"/change-language"})
public class LanguageServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String language = request.getParameter("lang");
        String referer = request.getHeader("Referer");

        // Set language in session and cookie
        if (language != null && !language.isEmpty()) {
            I18nUtil.setLanguage(request, response, language);

            // If user is logged in, update their language preference in database
            User user = (User) request.getSession().getAttribute("user");
            if (user != null) {
                try {
                    userService.updateLanguagePreference(user.getUserId(), language);
                    user.setPreferredLanguage(language); // Update in-memory object
                } catch (Exception e) {
                    request.getServletContext().log("Failed to update user language preference", e);
                }
            }
        }

        // Redirect back to referring page or home
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
