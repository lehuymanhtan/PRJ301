package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.User;
import services.EmailService;
import services.UserService;

/**
 * Handles password reset request (forgot password). GET: Show the forgot
 * password form POST: Process email and send reset link
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

            // Build reset link
            String contextPath = request.getContextPath();
            String baseUrl = request.getScheme() + "://" + request.getServerName();
            if (request.getServerPort() != 80 && request.getServerPort() != 443) {
                baseUrl += ":" + request.getServerPort();
            }
            String resetLink = baseUrl + contextPath + "/reset-password?token=" + user.getResetToken();

            // Language switching is disabled, always send Vietnamese template
            String language = "vi";
            boolean sent = EmailService.sendPasswordResetEmail(
                    user.getEmail(),
                    user.getName(),
                    resetLink,
                    language
            );

            if (sent) {
                request.setAttribute("success", "Password reset link has been sent to your email. Please check your inbox.");
            } else {
                request.setAttribute("error", "Failed to send reset email. Please try again later.");
            }

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred. Please try again.");
            // Log error for debugging
            request.getServletContext().log("Error in forgot password", e);
        }

        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }
}
