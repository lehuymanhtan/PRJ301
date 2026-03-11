package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.User;
import services.UserService;
import util.I18nUtil;
import java.io.IOException;

@WebServlet(urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Show any success message set by register
        String success = (String) request.getSession().getAttribute("successMessage");
        if (success != null) {
            request.setAttribute("success", success);
            request.getSession().removeAttribute("successMessage");
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Get the current language (from cookie, session, or browser) BEFORE login
        String currentLang = I18nUtil.getCurrentLanguage(request);

        User user = userService.login(username, password);

        if (user != null) {
            if (!user.isVerified()) {
                // Block login and redirect to verify page
                request.getSession().setAttribute("pendingVerificationEmail", user.getEmail());
                request.getSession().setAttribute("successMessage",
                        "Please verify your email before logging in.");
                response.sendRedirect(request.getContextPath() + "/verify");
                return;
            }

            HttpSession session = request.getSession();

            // Update user's language preference in database if different from saved preference
            if (!currentLang.equals(user.getPreferredLanguage())) {
                userService.updateLanguagePreference(user.getUserId(), currentLang);
                user.setPreferredLanguage(currentLang); // Update in-memory object
            }

            // Save user to session
            session.setAttribute("user", user);

            // Ensure language is set in session and cookie
            I18nUtil.setLanguage(request, response, user.getPreferredLanguage());

            if ("admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/products");
            }
        } else {
            request.setAttribute("error", "Invalid username or password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
