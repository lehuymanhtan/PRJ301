package services;

import models.OrderDetail;
import util.ResendUtil;
import java.text.DecimalFormat;
import java.util.List;

/**
 * High-level email service. Builds HTML content for each email type and
 * delegates the actual sending to {@link util.ResendUtil#sendMail}.
 *
 * The sender domain is read from the system property {@code RESEND_SEND_DOMAIN}
 * (populated at startup by AppContextListener from WEB-INF/.env).
 */
public class EmailService {

    private EmailService() {
    }

    private static String getSendDomain() {
        String domain = System.getProperty("RESEND_SEND_DOMAIN");
        return (domain != null && !domain.isEmpty()) ? domain : "resend.dev";
    }

    /**
     * Convenience: builds a "Display Name <noreply@domain>" sender string.
     */
    private static String buildFrom(String displayName) {
        return displayName + " <noreply@" + getSendDomain() + ">";
    }

    // ----------------------------------------------------------------
    // Verification email
    // ----------------------------------------------------------------
    /**
     * Sends an account-verification email containing a 6-digit code and a
     * one-click verification link.
     *
     * @param userEmail Recipient address
     * @param userName Recipient display name
     * @param code 6-digit OTP code
     * @param verifyLink Full URL to verify the account automatically
     * @param language User's preferred language (vi or en)
     * @return {@code true} if Resend accepted the email
     */
    public static boolean sendVerificationEmail(String userEmail, String userName,
            String code, String verifyLink, String language) {

        boolean isVietnamese = "vi".equalsIgnoreCase(language);

        String title = isVietnamese ? "Xác Thực Email Của Bạn" : "Verify Your Email";
        String greeting = isVietnamese ? "Xin chào" : "Hello";
        String thankYou = isVietnamese
                ? "Cảm ơn bạn đã đăng ký. Vui lòng xác thực địa chỉ email của bạn bằng một trong các cách sau."
                : "Thank you for registering. Please verify your email address using one of the options below.";
        String codeInstruction = isVietnamese
                ? "Nhập mã 6 chữ số này trên trang xác thực:"
                : "Enter this 6-digit code on the verification page:";
        String orInstruction = isVietnamese
                ? "Hoặc nhấn nút bên dưới để xác thực tự động:"
                : "Or click the button below to verify automatically:";
        String buttonText = isVietnamese ? "Xác Thực Email" : "Verify My Email";
        String expiry = isVietnamese
                ? "Mã và liên kết này sẽ hết hạn sau 24 giờ.<br>Nếu bạn không đăng ký, vui lòng bỏ qua email này."
                : "This code and link expire in 24 hours.<br>If you did not register, please ignore this email.";
        String footer = isVietnamese
                ? "Email này được gửi tự động bởi hệ thống cửa hàng."
                : "This email was sent automatically by our store system.";
        String subject = isVietnamese ? "Xác thực tài khoản RubyTech" : "Verify your RubyTech account";

        String html
                = "<div style='font-family:Arial,sans-serif;background:#f4f4f4;padding:20px'>"
                + "<div style='max-width:600px;margin:auto;background:white;border-radius:8px;padding:30px'>"
                + "<h2 style='color:#2c3e50;text-align:center'>&#x2709;&#xfe0f; " + title + "</h2>"
                + "<p>" + greeting + " <b>" + userName + "</b>,</p>"
                + "<p>" + thankYou + "</p>"
                + "<div style='text-align:center;margin:24px 0'>"
                + "<p style='font-size:14px;color:#555'>" + codeInstruction + "</p>"
                + "<div style='display:inline-block;font-size:36px;font-weight:bold;letter-spacing:8px;"
                + "background:#f0f0f0;padding:12px 24px;border-radius:6px;color:#2c3e50'>"
                + code
                + "</div>"
                + "</div>"
                + "<p style='text-align:center;font-size:14px;color:#555'>" + orInstruction + "</p>"
                + "<div style='text-align:center;margin:16px 0'>"
                + "<a href='" + verifyLink + "' style='background:#2e7d32;color:white;padding:12px 28px;"
                + "border-radius:4px;text-decoration:none;font-size:15px'>" + buttonText + "</a>"
                + "</div>"
                + "<p style='font-size:12px;color:#999;margin-top:24px'>" + expiry + "</p>"
                + "<hr>"
                + "<p style='font-size:11px;color:gray;text-align:center'>" + footer + "</p>"
                + "</div></div>";

        return ResendUtil.sendMail(
                buildFrom("RubyTech"),
                userEmail,
                subject,
                html
        );
    }

    /**
     * Sends an account-verification email (backward compatibility). Defaults to
     * English if language not specified.
     */
    public static boolean sendVerificationEmail(String userEmail, String userName,
            String code, String verifyLink) {
        return sendVerificationEmail(userEmail, userName, code, verifyLink, "en");
    }

    // ----------------------------------------------------------------
    // Order confirmation email
    // ----------------------------------------------------------------
    /**
     * Sends an order-confirmation email with a product table and the total.
     *
     * @param userEmail Recipient address
     * @param userName Recipient display name
     * @param orderId The order ID
     * @param items List of order line items
     * @return {@code true} if Resend accepted the email
     */
    public static boolean sendOrderEmail(String userEmail, String userName,
            int orderId, List<OrderDetail> items) {

        StringBuilder productTable = new StringBuilder();
        double total = 0;
        DecimalFormat moneyFormat = new DecimalFormat("#,###");

        for (OrderDetail item : items) {
            double subtotal = item.getPrice() * item.getQuantity();
            total += subtotal;

            productTable.append("<tr>")
                    .append("<td style='padding:8px;border-bottom:1px solid #ddd'>")
                    .append(item.getProductName())
                    .append("</td>")
                    .append("<td style='padding:8px;border-bottom:1px solid #ddd;text-align:center'>")
                    .append(item.getQuantity())
                    .append("</td>")
                    .append("<td style='padding:8px;border-bottom:1px solid #ddd;text-align:right'>")
                    .append(moneyFormat.format(subtotal))
                    .append(" VND</td>")
                    .append("</tr>");
        }

        String html
                = "<div style='font-family:Arial,sans-serif;background:#f4f4f4;padding:20px'>"
                + "<div style='max-width:600px;margin:auto;background:white;border-radius:8px;padding:20px'>"
                + "<h2 style='color:#2c3e50;text-align:center'>&#x1f6d2; Order Confirmation</h2>"
                + "<p>Hello <b>" + userName + "</b>,</p>"
                + "<p>Your order <b>#" + orderId + "</b> has been placed successfully.</p>"
                + "<h3 style='margin-top:20px'>Order Details</h3>"
                + "<table style='width:100%;border-collapse:collapse'>"
                + "<tr style='background:#2c3e50;color:white'>"
                + "<th style='padding:10px'>Product</th>"
                + "<th style='padding:10px'>Quantity</th>"
                + "<th style='padding:10px'>Price</th>"
                + "</tr>"
                + productTable.toString()
                + "</table>"
                + "<h3 style='text-align:right;margin-top:20px;color:#e74c3c'>Total: "
                + moneyFormat.format(total)
                + " VND</h3>"
                + "<p style='margin-top:30px'>Thank you for shopping with us &#x2764;&#xfe0f;</p>"
                + "<hr>"
                + "<p style='font-size:12px;color:gray;text-align:center'>"
                + "This email was sent automatically by our store system."
                + "</p>"
                + "</div></div>";

        return ResendUtil.sendMail(
                buildFrom("RubyTech"),
                userEmail,
                "Order #" + orderId + " Confirmation",
                html
        );
    }

    // ----------------------------------------------------------------
    // Password reset email
    // ----------------------------------------------------------------
    /**
     * Sends a password reset email containing a secure reset link.
     *
     * @param userEmail Recipient address
     * @param userName Recipient display name
     * @param resetLink Full URL to reset password page with token
     * @param language User's preferred language (vi or en)
     * @return {@code true} if Resend accepted the email
     */
    public static boolean sendPasswordResetEmail(String userEmail, String userName, String resetLink, String language) {
        boolean isVietnamese = "vi".equalsIgnoreCase(language);

        String title = isVietnamese ? "Đặt Lại Mật Khẩu" : "Reset Your Password";
        String greeting = isVietnamese ? "Xin chào" : "Hello";
        String intro = isVietnamese
                ? "Chúng tôi nhận được yêu cầu đặt lại mật khẩu của bạn. Nhấn nút bên dưới để tạo mật khẩu mới:"
                : "We received a request to reset your password. Click the button below to create a new password:";
        String buttonText = isVietnamese ? "Đặt Lại Mật Khẩu" : "Reset Password";
        String expiry = isVietnamese
                ? "Liên kết này sẽ hết hạn sau 30 phút.<br>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này và mật khẩu của bạn sẽ không thay đổi."
                : "This link will expire in 30 minutes.<br>If you did not request a password reset, please ignore this email and your password will remain unchanged.";
        String footer = isVietnamese
                ? "Email này được gửi tự động bởi hệ thống cửa hàng."
                : "This email was sent automatically by our store system.";
        String subject = isVietnamese ? "Đặt lại mật khẩu RubyTech" : "Reset your RubyTech password";

        String html
                = "<div style='font-family:Arial,sans-serif;background:#f4f4f4;padding:20px'>"
                + "<div style='max-width:600px;margin:auto;background:white;border-radius:8px;padding:30px'>"
                + "<h2 style='color:#2c3e50;text-align:center'>&#x1f512; " + title + "</h2>"
                + "<p>" + greeting + " <b>" + userName + "</b>,</p>"
                + "<p>" + intro + "</p>"
                + "<div style='text-align:center;margin:24px 0'>"
                + "<a href='" + resetLink + "' style='background:#e74c3c;color:white;padding:12px 28px;"
                + "border-radius:4px;text-decoration:none;font-size:15px'>" + buttonText + "</a>"
                + "</div>"
                + "<p style='font-size:12px;color:#999;margin-top:24px'>" + expiry + "</p>"
                + "<hr>"
                + "<p style='font-size:11px;color:gray;text-align:center'>" + footer + "</p>"
                + "</div></div>";

        return ResendUtil.sendMail(
                buildFrom("RubyTech"),
                userEmail,
                subject,
                html
        );
    }

    /**
     * Sends a password reset email (backward compatibility). Defaults to
     * English if language not specified.
     */
    public static boolean sendPasswordResetEmail(String userEmail, String userName, String resetLink) {
        return sendPasswordResetEmail(userEmail, userName, resetLink, "en");
    }

    // ----------------------------------------------------------------
    // Password changed confirmation email
    // ----------------------------------------------------------------
    /**
     * Sends a confirmation email after password has been successfully changed.
     *
     * @param userEmail Recipient address
     * @param userName Recipient display name
     * @param language User's preferred language (vi or en)
     * @return {@code true} if Resend accepted the email
     */
    public static boolean sendPasswordChangedEmail(String userEmail, String userName, String language) {
        boolean isVietnamese = "vi".equalsIgnoreCase(language);

        String title = isVietnamese ? "Mật Khẩu Đã Được Thay Đổi" : "Password Changed Successfully";
        String greeting = isVietnamese ? "Xin chào" : "Hello";
        String success = isVietnamese
                ? "Mật khẩu của bạn đã được thay đổi thành công. Bạn có thể đăng nhập bằng mật khẩu mới."
                : "Your password has been successfully changed. You can now log in with your new password.";
        String security = isVietnamese
                ? "Nếu bạn không thực hiện thay đổi này, vui lòng liên hệ với đội hỗ trợ ngay lập tức."
                : "If you did not make this change, please contact our support team immediately.";
        String footer = isVietnamese
                ? "Email này được gửi tự động bởi hệ thống cửa hàng."
                : "This email was sent automatically by our store system.";
        String subject = isVietnamese ? "Mật khẩu đã thay đổi - RubyTech" : "Password Changed - RubyTech";

        String html
                = "<div style='font-family:Arial,sans-serif;background:#f4f4f4;padding:20px'>"
                + "<div style='max-width:600px;margin:auto;background:white;border-radius:8px;padding:30px'>"
                + "<h2 style='color:#2c3e50;text-align:center'>&#x2705; " + title + "</h2>"
                + "<p>" + greeting + " <b>" + userName + "</b>,</p>"
                + "<p>" + success + "</p>"
                + "<p style='font-size:12px;color:#999;margin-top:24px'>" + security + "</p>"
                + "<hr>"
                + "<p style='font-size:11px;color:gray;text-align:center'>" + footer + "</p>"
                + "</div></div>";

        return ResendUtil.sendMail(
                buildFrom("RubyTech"),
                userEmail,
                subject,
                html
        );
    }

    /**
     * Sends a password changed confirmation email (backward compatibility).
     * Defaults to English if language not specified.
     */
    public static boolean sendPasswordChangedEmail(String userEmail, String userName) {
        return sendPasswordChangedEmail(userEmail, userName, "en");
    }
}
