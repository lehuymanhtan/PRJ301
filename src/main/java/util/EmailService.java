/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import models.OrderDetail;
import com.resend.*;
import com.resend.core.exception.ResendException;
import com.resend.services.emails.model.CreateEmailOptions;
import com.resend.services.emails.model.CreateEmailResponse;
import java.util.List;
import java.text.DecimalFormat;

/**
 * Centralised email utility using Resend.
 * The API key is read from the system property RESEND_API_KEY,
 * which is set at startup by AppContextListener from WEB-INF/.env.
 */
public class EmailService {

    private static String getApiKey() {
        String key = System.getProperty("RESEND_API_KEY");
        return (key != null && !key.isEmpty()) ? key : "";
    }

    // ----------------------------------------------------------------
    // Verification email
    // ----------------------------------------------------------------

    public static void sendVerificationEmail(String userEmail, String userName,
            String code, String verifyLink) {

        Resend resend = new Resend(getApiKey());

        String html
                = "<div style='font-family:Arial,sans-serif;background:#f4f4f4;padding:20px'>" 
                + "<div style='max-width:600px;margin:auto;background:white;border-radius:8px;padding:30px'>" 
                + "<h2 style='color:#2c3e50;text-align:center'>✉️ Verify Your Email</h2>" 
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

        CreateEmailOptions params = CreateEmailOptions.builder()
                .from("RubyTech <onboarding@resend.dev>")
                .to(userEmail)
                .subject("Verify your RubyTech account")
                .html(html)
                .build();

        try {
            CreateEmailResponse data = resend.emails().send(params);
            System.out.println("Verification email sent: " + data.getId());
        } catch (ResendException e) {
            e.printStackTrace();
        }
    }

    // ----------------------------------------------------------------
    // Order confirmation email
    // ----------------------------------------------------------------

    public static void sendOrderEmail(String userEmail, String userName,
            int orderId, List<OrderDetail> items) {

        Resend resend = new Resend(getApiKey());

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
                + "<h2 style='color:#2c3e50;text-align:center'>🛒 Order Confirmation</h2>"
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
                + "<p style='margin-top:30px'>Thank you for shopping with us ❤️</p>"
                + "<hr>"
                + "<p style='font-size:12px;color:gray;text-align:center'>"
                + "This email was sent automatically by our store system."
                + "</p>"
                + "</div></div>";
        CreateEmailOptions params = CreateEmailOptions.builder()
                .from("RubyTech <onboarding@resend.dev>")
                .to(userEmail)
                .subject("Order #" + orderId + " Confirmation")
                .html(html)
                .build();

        try {
            CreateEmailResponse data = resend.emails().send(params);
            System.out.println("Email sent: " + data.getId());
        } catch (ResendException e) {
            e.printStackTrace();
        }
    }
}

    public static void sendOrderEmail(String userEmail, String userName,
            int orderId, List<OrderDetail> items) {

        Resend resend = new Resend(API_KEY);

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
                + "<h2 style='color:#2c3e50;text-align:center'>🛒 Order Confirmation</h2>"
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
                + "<p style='margin-top:30px'>Thank you for shopping with us ❤️</p>"
                + "<hr>"
                + "<p style='font-size:12px;color:gray;text-align:center'>"
                + "This email was sent automatically by our store system."
                + "</p>"
                + "</div></div>";
        CreateEmailOptions params = CreateEmailOptions.builder()
                .from("RubyTech <onboarding@resend.dev>")
                .to(userEmail)
                .subject("Order #" + orderId + " Confirmation")
                .html(html)
                .build();

        try {
            CreateEmailResponse data = resend.emails().send(params);
            System.out.println("Email sent: " + data.getId());
        } catch (ResendException e) {
            e.printStackTrace();
        }
    }
}
