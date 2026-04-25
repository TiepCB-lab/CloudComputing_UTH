/* === FILE: frontend/js/auth.js === */

const API_AUTH_URL = "/backend/api/auth";

document.addEventListener('DOMContentLoaded', async () => {
    // 1. Setup các hiệu ứng giao diện (luôn chạy)
    addHeaderScrollEffect();
    setupModalListeners();
    setupHeaderSearchListeners();
    setupUserMenuListeners(); 
    
    // 2. KIỂM TRA ĐĂNG NHẬP NGAY KHI TẢI TRANG
    await checkLoginStatus(); 

    // 3. Xử lý Form Đăng nhập (nếu có trên trang hiện tại)
    const loginForm = document.getElementById("login-form");
    if (loginForm) {
        loginForm.addEventListener("submit", handleLogin);
    }

    // 4. Xử lý Form Đăng kí (nếu có trên trang hiện tại)
    const registerForm = document.getElementById("register-form");
    if (registerForm) {
        registerForm.addEventListener("submit", handleRegister);
    }
});

/**
 * ⭐ HÀM 1: KIỂM TRA TRẠNG THÁI ĐĂNG NHẬP
 * Gọi API me.php để lấy thông tin user (bao gồm role)
 */
async function checkLoginStatus() {
    try {
        const res = await fetch(`${API_AUTH_URL}/me.php`, {
            method: "GET",
            credentials: "include" // Quan trọng: Gửi cookie session lên server
        });

        if (res.ok) {
            const userData = await res.json();
            // userData sẽ có dạng: { id: 1, username: "Tâm Phú", role: "admin", ... }
            updateHeaderUI(userData); 
        } else {
            updateHeaderUI(null);
        }
    } catch (err) {
        console.error(err);
        updateHeaderUI(null);
    }
}

/**
 * ⭐ HÀM 2: CẬP NHẬT GIAO DIỆN HEADER (QUAN TRỌNG NHẤT)
 * Hàm này sẽ tự động tạo nút Admin nếu user.role là 'admin'
 */
function updateHeaderUI(user) {
    const userMenuBtn = document.getElementById("user-menu-btn");
    const userDropdown = document.getElementById("user-dropdown");

    if (!userMenuBtn || !userDropdown) return;

    if (user) {
        // === TRƯỜNG HỢP ĐÃ ĐĂNG NHẬP ===
        
        // 1. Hiển thị tên user
        userMenuBtn.innerHTML = `<i class="fa-solid fa-user"></i> Chào, ${user.username}`;
        
        // 2. Tạo danh sách menu
        let menuHtml = `<a href="profile.html"><i class="fa-solid fa-id-card"></i> Tài khoản của tôi</a>`;

        // ⭐ ĐOẠN NÀY TỰ ĐỘNG TẠO NÚT ADMIN ⭐
        // Nếu role là 'admin' thì cộng thêm dòng HTML này vào menu
        if (user.role === 'admin') {
            menuHtml += `<a href="admin/index.html" style="color: #e50914; font-weight: bold; border-top: 1px solid #333;">
                            <i class="fa-solid fa-gauge"></i> Trang Quản Trị
                         </a>`;
        }
        // -------------------------------------

        menuHtml += `<a href="#" id="logout-btn"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>`;
        
        // 3. Gán HTML vào dropdown
        userDropdown.innerHTML = menuHtml;
        
        // 4. Gán sự kiện cho nút Đăng xuất vừa tạo
        const logoutBtn = document.getElementById("logout-btn");
        if(logoutBtn) {
            logoutBtn.addEventListener("click", async (e) => {
                e.preventDefault();
                await fetch(`${API_AUTH_URL}/logout.php`, { credentials: "include" });
                window.location.href = "index.html";
            });
        }

    } else {
        // === TRƯỜNG HỢP CHƯA ĐĂNG NHẬP ===
        userMenuBtn.innerHTML = `<i class="fa-solid fa-user"></i>`;
        userDropdown.innerHTML = `
            <a href="login.html">Đăng nhập</a>
            <a href="register.html">Đăng kí</a>
        `;
    }
}

/**
 * ⭐ HÀM 3: XỬ LÝ ĐĂNG NHẬP
 */
async function handleLogin(e) {
    e.preventDefault();
    const email = document.getElementById("email").value;
    const password = document.getElementById("password").value;
    const btn = document.querySelector("#login-form .btn-primary");
    
    const originalText = btn.textContent;
    btn.disabled = true;
    btn.textContent = "Đang xử lý...";

    try {
        const res = await fetch(`${API_AUTH_URL}/login.php`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            credentials: "include", 
            body: JSON.stringify({ email, password })
        });

        const data = await res.json();

        if (res.ok) {
            // alert(data.message); 
            
            // ⭐ SỬA Ở ĐÂY: LUÔN LUÔN CHUYỂN VỀ TRANG CHỦ ⭐
            // Bất kể là Admin hay User thì đều về index.html
            // Nút "Trang Quản Trị" đã có sẵn trong Menu (do hàm updateHeaderUI vẽ ra)
            window.location.href = "index.html"; 

        } else {
            alert(data.message);
            btn.disabled = false;
            btn.textContent = originalText;
        }
    } catch (err) {
        console.error(err);
        alert("Lỗi kết nối server.");
        btn.disabled = false;
        btn.textContent = originalText;
    }
}
/**
 * Xử lý Đăng kí (Giữ nguyên)
 */
async function handleRegister(e) {
    e.preventDefault();
    const username = document.getElementById("username").value;
    const email = document.getElementById("email").value;
    const password = document.getElementById("password").value;
    const confirmPass = document.getElementById("confirm-password").value;

    if (password !== confirmPass) {
        alert("Mật khẩu xác nhận không khớp!");
        return;
    }

    try {
        const res = await fetch(`${API_AUTH_URL}/register.php`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ username, email, password })
        });

        const data = await res.json();
        alert(data.message);

        if (res.ok) {
            window.location.href = "login.html";
        }
    } catch (err) {
        alert("Lỗi kết nối máy chủ.");
    }
}

/* ==========================================================
   CÁC HÀM HELPER GIAO DIỆN (Không cần sửa)
   ========================================================== */

function addHeaderScrollEffect() {
    const header = document.querySelector('.main-header');
    if(header) window.addEventListener('scroll', () => header.classList.toggle('scrolled', window.scrollY > 50));
}

function setupModalListeners() {
    const modal = document.getElementById('trailer-modal');
    if (!modal) return;
    const closeBtn = document.getElementById('modal-close-btn');
    const iframe = document.getElementById('trailer-iframe');

    document.body.addEventListener('click', e => {
        const btn = e.target.closest('.btn-open-modal');
        if (btn) {
            const url = btn.dataset.trailerUrl;
            if (url) {
                iframe.src = `${url}?autoplay=1`;
                modal.classList.add('active');
            }
        }
    });

    const closeModal = () => {
        modal.classList.remove('active');
        if(iframe) iframe.src = '';
    };

    if(closeBtn) closeBtn.addEventListener('click', closeModal);
    modal.addEventListener('click', e => { if (e.target === modal) closeModal(); });
}

function setupHeaderSearchListeners() {
    const input = document.getElementById('header-search-input');
    const btn = document.getElementById('header-search-btn');
    if(input && btn) {
        const doSearch = () => { 
            const q = input.value.trim(); 
            window.location.href = q ? `movies.html?q=${encodeURIComponent(q)}` : 'movies.html'; 
        };
        input.addEventListener('keydown', e => { if (e.key === 'Enter') doSearch(); });
        btn.addEventListener('click', doSearch);
    }
}

function setupUserMenuListeners() {
    const btn = document.getElementById('user-menu-btn');
    const dropdown = document.getElementById('user-dropdown');
    if(btn && dropdown) {
        btn.addEventListener('click', (e) => { e.stopPropagation(); dropdown.classList.toggle('active'); });
        window.addEventListener('click', () => dropdown.classList.remove('active'));
    }
}