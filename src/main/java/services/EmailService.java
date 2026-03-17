package services;

import models.OrderDetail;
import util.ResendUtil;
import java.text.DecimalFormat;
import java.util.List;

/**
 * High-level email service.
 * Builds HTML content for each email type and delegates the actual sending
 * to {@link util.ResendUtil#sendMail}.
 *
 * The sender domain is read from the system property {@code RESEND_SEND_DOMAIN}
 * (populated at startup by AppContextListener from WEB-INF/.env).
 */
public class EmailService {

    private EmailService() {}

    private static String getSendDomain() {
        String domain = System.getProperty("RESEND_SEND_DOMAIN");
        return (domain != null && !domain.isEmpty()) ? domain : "resend.dev";
    }

    /** Convenience: builds a "Display Name <noreply@domain>" sender string. */
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
     * @param userEmail  Recipient address
     * @param userName   Recipient display name
     * @param code       6-digit OTP code
     * @param verifyLink Full URL to verify the account automatically
     * @return {@code true} if Resend accepted the email
     */
    public static boolean sendVerificationEmail(String userEmail, String userName,
            String code, String verifyLink) {

        String html
                = "<div style='font-family:Arial,sans-serif;background:#f4f4f4;padding:20px'>"
                + "<div style='max-width:600px;margin:auto;background:white;border-radius:8px;padding:30px'>"
                + "<h2 style='color:#2c3e50;text-align:center'>&#x2709;&#xfe0f; Verify Your Email</h2>"
                + "<p>Hello <b>" + userName + "</b>,</p>"
                + "<p>Thank you for registering. Please verify your email address using one of the options below.</p>"
                + "<div style='text-align:center;margin:24px 0'>"
                + "<p style='font-size:14px;color:#555'>Enter this 6-digit code on the verification page:</p>"
                + "<div style='display:inline-block;font-size:36px;font-weight:bold;letter-spacing:8px;"
                + "background:#f0f0f0;padding:12px 24px;border-radius:6px;color:#2c3e50'>"
                + code
                + "</div>"
                + "</div>"
                + "<p style='text-align:center;font-size:14px;color:#555'>Or click the button below to verify automatically:</p>"
                + "<div style='text-align:center;margin:16px 0'>"
                + "<a href='" + verifyLink + "' style='background:#2e7d32;color:white;padding:12px 28px;"
                + "border-radius:4px;text-decoration:none;font-size:15px'>Verify My Email</a>"
                + "</div>"
                + "<p style='font-size:12px;color:#999;margin-top:24px'>This code and link expire in 24 hours.<br>"
                + "If you did not register, please ignore this email.</p>"
                + "<hr>"
                + "<p style='font-size:11px;color:gray;text-align:center'>"
                + "This email was sent automatically by our store system."
                + "</p>"
                + "</div></div>";

        return ResendUtil.sendMail(
                buildFrom("RubyTech"),
                userEmail,
                "Verify your RubyTech account",
                html
        );
    }

    // ----------------------------------------------------------------
    // Order confirmation email
    // ----------------------------------------------------------------

    /**
     * Sends an order-confirmation email with a product table and the total.
     *
     * @param userEmail Recipient address
     * @param userName  Recipient display name
     * @param orderId   The order ID
     * @param items     List of order line items
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
}
