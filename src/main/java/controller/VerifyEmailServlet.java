package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.User;
import services.UserService;
import services.EmailService;
import java.io.IOException;

/**
 * Handles email verification after registration.
 *
 * GET  /verify              – Show the verification form (email pre-filled from session).
 * GET  /verify?token=...    – One-click verification via the link in the email.
 * POST /verify (action=verify)  – Verify using the 6-digit code.
 * POST /verify (action=resend)  – Resend the verification email.
 */
@WebServlet(urlPatterns = {"/verify"})
public class VerifyEmailServlet extends HttpServlet {

    private final UserService userService = new UserService();

    // ----------------------------------------------------------------
    // GET
    // ----------------------------------------------------------------

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");

        if (token != null && !token.isBlank()) {
            // One-click link from email
            boolean ok = userService.verifyByToken(token);
            if (ok) {
                request.getSession().setAttribute("successMessage",
                        "Email verified successfully! You can now log in.");
            } else {
                request.getSession().setAttribute("successMessage",
                        "Verification link is invalid or has expired. Please request a new code.");
            }
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Show verify form; pick up email from session
        String email = (String) request.getSession().getAttribute("pendingVerificationEmail");
        request.setAttribute("email", email);

        // Pass any flash message from session
        String msg = (String) request.getSession().getAttribute("successMessage");
        if (msg != null) {
            request.setAttribute("info", msg);
            request.getSession().removeAttribute("successMessage");
        }

        request.getRequestDispatcher("/verify.jsp").forward(request, response);
    }

    // ----------------------------------------------------------------
    // POST
    // ----------------------------------------------------------------

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String email  = request.getParameter("email");

        if ("resend".equals(action)) {
            handleResend(request, response, email);
        } else {
            handleVerifyCode(request, response, email);
        }
    }

    // ---- Verify by code ----

    private void handleVerifyCode(HttpServletRequest request, HttpServletResponse response,
                                   String email) throws ServletException, IOException {

        String code = request.getParameter("code");

        if (email == null || email.isBlank() || code == null || code.isBlank()) {
            request.setAttribute("email", email);
            request.setAttribute("error", "Please enter your email and the verification code.");
            request.getRequestDispatcher("/verify.jsp").forward(request, response);
            return;
        }

        boolean ok = userService.verifyByCode(email.trim(), code.trim());

        if (ok) {
            request.getSession().removeAttribute("pendingVerificationEmail");
            request.getSession().setAttribute("successMessage",
                    "Email verified successfully! You can now log in.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("email", email);
            request.setAttribute("error",
                    "Invalid or expired verification code. Please try again or request a new one.");
            request.getRequestDispatcher("/verify.jsp").forward(request, response);
        }
    }

    // ---- Resend code ----

    private void handleResend(HttpServletRequest request, HttpServletResponse response,
                               String email) throws ServletException, IOException {

        if (email == null || email.isBlank()) {
            request.setAttribute("error", "Please provide your email address.");
            request.getRequestDispatcher("/verify.jsp").forward(request, response);
            return;
        }

        try {
            User user = userService.refreshVerification(email.trim());

            String baseUrl = request.getScheme() + "://" + request.getServerName()
                    + ":" + request.getServerPort() + request.getContextPath();
            String verifyLink = baseUrl + "/verify?token=" + user.getVerificationToken();

            final String finalEmail = user.getEmail();
            final String finalName  = user.getName();
            final String finalCode  = user.getVerificationCode();
            final String finalLink  = verifyLink;
            new Thread(() -> EmailService.sendVerificationEmail(finalEmail, finalName, finalCode, finalLink)).start();

            request.getSession().setAttribute("pendingVerificationEmail", user.getEmail());
            request.setAttribute("email", user.getEmail());
            request.setAttribute("info", "A new verification code has been sent to " + user.getEmail() + ".");
        } catch (IllegalArgumentException e) {
            request.setAttribute("email", email);
            request.setAttribute("error", e.getMessage());
        }

        request.getRequestDispatcher("/verify.jsp").forward(request, response);
    }
}
