package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.User;
import services.EmailService;
import services.UserService;
import java.io.IOException;

/**
 * Handles password reset request (forgot password).
 * GET: Show the forgot password form
 * POST: Process email and send reset link
 */
@WebServlet(urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email is required");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }

        try {
            User user = userService.initiatePasswordReset(email.trim());

            if (user == null) {
                // Don't reveal whether email exists or not (security best practice)
                request.setAttribute("success", "If an account with that email exists, a password reset link has been sent.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            // Build reset link
            String contextPath = request.getContextPath();
            String baseUrl = request.getScheme() + "://" + request.getServerName();
            if (request.getServerPort() != 80 && request.getServerPort() != 443) {
                baseUrl += ":" + request.getServerPort();
            }
            String resetLink = baseUrl + contextPath + "/reset-password?token=" + user.getResetToken();

            // Send reset email
            boolean sent = EmailService.sendPasswordResetEmail(
                    user.getEmail(),
                    user.getName(),
                    resetLink
            );

            if (sent) {
                request.setAttribute("success", "Password reset link has been sent to your email. Please check your inbox.");
            } else {
                request.setAttribute("error", "Failed to send reset email. Please try again later.");
            }

        } catch (Exception e) {
            request.setAttribute("error", "An error occurred. Please try again.");
            request.getServletContext().log("Error in forgot password", e);
        }

        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }
}
