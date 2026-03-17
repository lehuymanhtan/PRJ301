package filter;

import models.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/users", "/users/*", "/cart", "/checkout", "/orders", "/refund"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        User user = (session != null) ? (User) session.getAttribute("user") : null;
        String path = req.getServletPath();

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if (path.startsWith("/admin") && !"admin".equalsIgnoreCase(user.getRole())) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied. Admin only.");
            return;
        }

        chain.doFilter(request, response);
    }
}
