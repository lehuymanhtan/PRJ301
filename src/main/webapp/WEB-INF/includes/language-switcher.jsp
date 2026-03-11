<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%-- Language Switcher Component Include this in any page to add language switching functionality Usage: <%@ include
        file="/WEB-INF/includes/language-switcher.jsp" %>
        --%>
        <div class="language-switcher">
            <% String currentLang=(String) request.getAttribute("currentLang"); if (currentLang==null) currentLang="en"
                ; String contextPath=request.getContextPath(); %>
                <select onchange="changeLanguage(this.value)" class="lang-select">
                    <option value="en" <%="en" .equals(currentLang) ? "selected" : "" %>>🇬🇧 English</option>
                    <option value="vi" <%="vi" .equals(currentLang) ? "selected" : "" %>>🇻🇳 Tiếng Việt</option>
                </select>
        </div>

        <style>
            .language-switcher {
                display: inline-block;
            }

            .lang-select {
                padding: 6px 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                background: white;
                cursor: pointer;
                font-size: 14px;
            }

            .lang-select:hover {
                border-color: #999;
            }
        </style>

        <script>
            function changeLanguage(lang) {
                const currentUrl = window.location.href;
                const url = new URL(currentUrl);
                url.searchParams.set('lang', lang);
                window.location.href = url.toString();
            }
        </script>