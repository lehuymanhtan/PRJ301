package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import services.EmailService;
import services.UserService;

/**
 * Handles password reset with token. GET: Show reset password form (validates
 * token) POST: Process new password and update
 */
@WebServlet(urlPatterns = {"/reset-password"})
public class ResetPasswordServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");

        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Invalid reset link");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }

        // Validate token
        User user = userService.validateResetToken(token);
        if (user == null) {
            request.setAttribute("error", "This reset link is invalid or has expired. Please request a new one.");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }

        // Token is valid, show form
        request.setAttribute("token", token);
        request.setAttribute("email", user.getEmail());
        request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Invalid reset token");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }

        if (newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("error", "Password is required");
            request.setAttribute("token", token);
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.setAttribute("token", token);
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }

        try {
            // Get user info before resetting (for sending email)
            User user = userService.validateResetToken(token);
            if (user == null) {
                request.setAttribute("error", "This reset link is invalid or has expired. Please request a new one.");
                request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
                return;
            }

            // Reset password
            boolean success = userService.resetPassword(token, newPassword);

            if (success) {
                // Language switching is disabled, always send English template
                String language = "en";
                EmailService.sendPasswordChangedEmail(user.getEmail(), user.getName(), language);

                // Redirect to login with success message
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Your password has been reset successfully. Please log in with your new password.");
                response.sendRedirect(request.getContextPath() + "/login");
            } else {
                request.setAttribute("error", "Failed to reset password. Please try again.");
                request.setAttribute("token", token);
                request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            }

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("token", token);
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
        } catch (ServletException | IOException e) {
            // Rethrow servlet exceptions
            throw e;
        } catch (RuntimeException e) {
            request.setAttribute("error", "An error occurred. Please try again.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            // Log error for debugging
            request.getServletContext().log("Error in reset password", e);
        }
    }
}
