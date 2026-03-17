<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="${currentLang}">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${i18n.get('admin.product.edit')} - ${i18n.get('admin.title')}</title>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    min-height: 100vh;
                    padding: 20px;
                }

                .container {
                    max-width: 1200px;
                    margin: 0 auto;
                    background: white;
                    border-radius: 15px;
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
                    overflow: hidden;
                }

                .header {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                    padding: 30px;
                    text-align: center;
                }

                .header h1 {
                    font-size: 28px;
                    margin-bottom: 10px;
                }

                .header p {
                    opacity: 0.9;
                    font-size: 14px;
                }

                .content {
                    padding: 40px;
                }

                .nav-links {
                    margin-bottom: 30px;
                    display: flex;
                    gap: 15px;
                }

                .nav-links a {
                    text-decoration: none;
                    color: #667eea;
                    padding: 8px 16px;
                    border: 2px solid #667eea;
                    border-radius: 5px;
                    transition: all 0.3s;
                }

                .nav-links a:hover {
                    background: #667eea;
                    color: white;
                }

                .language-tabs {
                    display: flex;
                    gap: 10px;
                    margin-bottom: 30px;
                    border-bottom: 2px solid #e0e0e0;
                }

                .language-tab {
                    padding: 15px 30px;
                    cursor: pointer;
                    border: none;
                    background: none;
                    font-size: 16px;
                    font-weight: 600;
                    color: #666;
                    border-bottom: 3px solid transparent;
                    transition: all 0.3s;
                }

                .language-tab.active {
                    color: #667eea;
                    border-bottom-color: #667eea;
                }

                .language-tab:hover {
                    color: #667eea;
                }

                .language-content {
                    display: none;
                }

                .language-content.active {
                    display: block;
                }

                .form-section {
                    background: #f8f9fa;
                    padding: 25px;
                    border-radius: 10px;
                    margin-bottom: 20px;
                }

                .form-section h3 {
                    color: #333;
                    margin-bottom: 20px;
                    font-size: 18px;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .form-row {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 20px;
                    margin-bottom: 20px;
                }

                .form-group {
                    margin-bottom: 20px;
                }

                .form-group label {
                    display: block;
                    margin-bottom: 8px;
                    font-weight: 600;
                    color: #333;
                    font-size: 14px;
                }

                .form-group label .required {
                    color: #e74c3c;
                }

                .form-group label .optional {
                    color: #999;
                    font-weight: normal;
                    font-size: 12px;
                }

                .form-group input,
                .form-group select,
                .form-group textarea {
                    width: 100%;
                    padding: 12px;
                    border: 2px solid #e0e0e0;
                    border-radius: 8px;
                    font-size: 14px;
                    transition: border-color 0.3s;
                }

                .form-group textarea {
                    min-height: 120px;
                    resize: vertical;
                }

                .form-group input:focus,
                .form-group select:focus,
                .form-group textarea:focus {
                    outline: none;
                    border-color: #667eea;
                }

                .help-text {
                    font-size: 12px;
                    color: #666;
                    margin-top: 5px;
                }

                .alert {
                    padding: 15px 20px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                    border-left: 4px solid;
                }

                .alert-success {
                    background: #d4edda;
                    border-left-color: #28a745;
                    color: #155724;
                }

                .alert-error {
                    background: #f8d7da;
                    border-left-color: #dc3545;
                    color: #721c24;
                }

                .alert-info {
                    background: #d1ecf1;
                    border-left-color: #17a2b8;
                    color: #0c5460;
                }

                .button-group {
                    display: flex;
                    gap: 15px;
                    margin-top: 30px;
                }

                .btn {
                    padding: 12px 30px;
                    border: none;
                    border-radius: 8px;
                    font-size: 16px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.3s;
                    text-decoration: none;
                    display: inline-block;
                    text-align: center;
                }

                .btn-primary {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                }

                .btn-primary:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
                }

                .btn-secondary {
                    background: #6c757d;
                    color: white;
                }

                .btn-secondary:hover {
                    background: #5a6268;
                }

                .language-indicator {
                    display: inline-flex;
                    align-items: center;
                    gap: 5px;
                    padding: 4px 10px;
                    background: #667eea;
                    color: white;
                    border-radius: 20px;
                    font-size: 12px;
                    font-weight: 600;
                }

                .flag {
                    font-size: 16px;
                }

                @media (max-width: 768px) {
                    .form-row {
                        grid-template-columns: 1fr;
                    }

                    .content {
                        padding: 20px;
                    }

                    .language-tab {
                        padding: 10px 15px;
                        font-size: 14px;
                    }
                }
            </style>
        </head>

        <body>
            <div class="container">
                <div class="header">
                    <h1>📝 ${i18n.get('admin.product.multilingual')}</h1>
                    <p>${i18n.get('admin.product.multilingual.description')}</p>
                </div>

                <div class="content">
                    <div class="nav-links">
                        <a href="${pageContext.request.contextPath}/admin/dashboard">🏠 ${i18n.get('nav.dashboard')}</a>
                        <a href="${pageContext.request.contextPath}/admin/products">📦 ${i18n.get('nav.products')}</a>
                    </div>

                    <c:if test="${not empty success}">
                        <div class="alert alert-success">✓ ${success}</div>
                    </c:if>

                    <c:if test="${not empty error}">
                        <div class="alert alert-error">✗ ${error}</div>
                    </c:if>

                    <div class="alert alert-info">
                        💡 <strong>${i18n.get('admin.product.tip')}:</strong>
                        ${i18n.get('admin.product.tip.description')}
                    </div>

                    <form action="${pageContext.request.contextPath}/admin/products/save-multilingual" method="post">
                        <input type="hidden" name="id" value="${product.id}">

                        <!-- Common Fields (Non-multilingual) -->
                        <div class="form-section">
                            <h3>🔧 ${i18n.get('admin.product.common')}</h3>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="price">
                                        ${i18n.get('product.price')} <span class="required">*</span>
                                    </label>
                                    <input type="number" id="price" name="price" value="${product.price}" required
                                        min="0" step="1000">
                                    <p class="help-text">${i18n.get('admin.product.price.help')}</p>
                                </div>

                                <div class="form-group">
                                    <label for="stock">
                                        ${i18n.get('product.stock')} <span class="required">*</span>
                                    </label>
                                    <input type="number" id="stock" name="stock" value="${product.stock}" required
                                        min="0">
                                    <p class="help-text">${i18n.get('admin.product.stock.help')}</p>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="importDate">
                                        ${i18n.get('product.importDate')} <span
                                            class="optional">(${i18n.get('common.optional')})</span>
                                    </label>
                                    <input type="date" id="importDate" name="importDate" value="${product.importDate}">
                                </div>

                                <div class="form-group">
                                    <label for="supplierId">
                                        ${i18n.get('product.supplier')} <span
                                            class="optional">(${i18n.get('common.optional')})</span>
                                    </label>
                                    <select id="supplierId" name="supplierId">
                                        <option value="">-- ${i18n.get('common.select')} --</option>
                                        <c:forEach var="supplier" items="${suppliers}">
                                            <option value="${supplier.id}" ${product.supplierId==supplier.id
                                                ? 'selected' : '' }>
                                                ${supplier.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Language Tabs -->
                        <div class="language-tabs">
                            <button type="button" class="language-tab active" data-lang="vi">
                                <span class="flag">🇻🇳</span> Tiếng Việt
                            </button>
                            <button type="button" class="language-tab" data-lang="en">
                                <span class="flag">🇬🇧</span> English
                            </button>
                        </div>

                        <!-- Vietnamese Content -->
                        <div class="language-content active" data-lang="vi">
                            <div class="form-section">
                                <h3>
                                    <span class="language-indicator">
                                        <span class="flag">🇻🇳</span> VI
                                    </span>
                                    ${i18n.get('admin.product.vietnamese')}
                                </h3>

                                <div class="form-group">
                                    <label for="name_vi">
                                        ${i18n.get('product.name')} (Tiếng Việt) <span class="required">*</span>
                                    </label>
                                    <input type="text" id="name_vi" name="name" value="${product.name}" required
                                        maxlength="100">
                                    <p class="help-text">Tên sản phẩm bằng tiếng Việt (bắt buộc)</p>
                                </div>

                                <div class="form-group">
                                    <label for="description_vi">
                                        ${i18n.get('product.description')} (Tiếng Việt) <span
                                            class="optional">(${i18n.get('common.optional')})</span>
                                    </label>
                                    <textarea id="description_vi" name="description"
                                        maxlength="500">${product.description}</textarea>
                                    <p class="help-text">Mô tả chi tiết sản phẩm bằng tiếng Việt</p>
                                </div>

                                <div class="form-group">
                                    <label for="category_vi">
                                        ${i18n.get('product.category')} (Tiếng Việt) <span
                                            class="optional">(${i18n.get('common.optional')})</span>
                                    </label>
                                    <input type="text" id="category_vi" name="category" value="${product.category}"
                                        maxlength="100">
                                    <p class="help-text">Ví dụ: Điện tử, Phụ kiện, Nội thất</p>
                                </div>
                            </div>
                        </div>

                        <!-- English Content -->
                        <div class="language-content" data-lang="en">
                            <div class="form-section">
                                <h3>
                                    <span class="language-indicator">
                                        <span class="flag">🇬🇧</span> EN
                                    </span>
                                    ${i18n.get('admin.product.english')}
                                </h3>

                                <div class="form-group">
                                    <label for="name_en">
                                        ${i18n.get('product.name')} (English) <span
                                            class="optional">(${i18n.get('common.optional')})</span>
                                    </label>
                                    <input type="text" id="name_en" name="name_en" value="${product.name_en}"
                                        maxlength="100">
                                    <p class="help-text">Product name in English (if empty, will use Vietnamese name)
                                    </p>
                                </div>

                                <div class="form-group">
                                    <label for="description_en">
                                        ${i18n.get('product.description')} (English) <span
                                            class="optional">(${i18n.get('common.optional')})</span>
                                    </label>
                                    <textarea id="description_en" name="description_en"
                                        maxlength="500">${product.description_en}</textarea>
                                    <p class="help-text">Detailed product description in English</p>
                                </div>

                                <div class="form-group">
                                    <label for="category_en">
                                        ${i18n.get('product.category')} (English) <span
                                            class="optional">(${i18n.get('common.optional')})</span>
                                    </label>
                                    <input type="text" id="category_en" name="category_en"
                                        value="${product.category_en}" maxlength="100">
                                    <p class="help-text">Example: Electronics, Accessories, Furniture</p>
                                </div>
                            </div>
                        </div>

                        <div class="button-group">
                            <button type="submit" class="btn btn-primary">
                                💾 ${i18n.get('common.save')}
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">
                                ✗ ${i18n.get('common.cancel')}
                            </a>
                        </div>
                    </form>
                </div>
            </div>

            <script>
                // Language tab switching
                const tabs = document.querySelectorAll('.language-tab');
                const contents = document.querySelectorAll('.language-content');

                tabs.forEach(tab => {
                    tab.addEventListener('click', () => {
                        const lang = tab.getAttribute('data-lang');

                        // Update tabs
                        tabs.forEach(t => t.classList.remove('active'));
                        tab.classList.add('active');

                        // Update content
                        contents.forEach(content => {
                            content.classList.remove('active');
                            if (content.getAttribute('data-lang') === lang) {
                                content.classList.add('active');
                            }
                        });
                    });
                });

                // Form validation
                document.querySelector('form').addEventListener('submit', (e) => {
                    const nameVi = document.getElementById('name_vi').value.trim();
                    const price = document.getElementById('price').value;
                    const stock = document.getElementById('stock').value;

                    if (!nameVi) {
                        e.preventDefault();
                        alert('${i18n.get("admin.product.error.name.required")}');
                        document.querySelector('.language-tab[data-lang="vi"]').click();
                        document.getElementById('name_vi').focus();
                        return;
                    }

                    if (!price || price <= 0) {
                        e.preventDefault();
                        alert('${i18n.get("admin.product.error.price.invalid")}');
                        document.getElementById('price').focus();
                        return;
                    }

                    if (!stock || stock < 0) {
                        e.preventDefault();
                        alert('${i18n.get("admin.product.error.stock.invalid")}');
                        document.getElementById('stock').focus();
                        return;
                    }
                });
            </script>
        </body>

        </html>