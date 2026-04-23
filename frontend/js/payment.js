const API_BASE_URL = "http://localhost/LT-Web_Dat-Ve-Xem-Phim/backend/api";

// Biến toàn cục
let originalTotalAmount = 0; 
let currentDiscount = 0;
let currentVoucherCode = null;
let allVouchers = []; // Biến mới: Lưu danh sách voucher tải từ API

document.addEventListener('DOMContentLoaded', async () => {
    await checkLoginStatus();

    // 1. QUAN TRỌNG: Hiển thị thông tin vé từ Session
    initializePaymentPage(); 

    // 2. Tải danh sách Voucher & Render vào Modal (Logic mới)
    await loadVoucherList();

    setupPaymentTabs();

    // 3. Gán sự kiện nút thanh toán
    document.getElementById('confirm-payment')?.addEventListener('click', processRealPayment);
    
    // 4. Thiết lập sự kiện cho Modal Voucher (Mở/Đóng/Xóa)
    setupVoucherModalEvents();
});

// --- HÀM 1: KHỞI TẠO TRANG (HIỂN THỊ THÔNG TIN VÉ) ---
function initializePaymentPage() {
    const dataString = sessionStorage.getItem('bookingDetails');
    
    if (!dataString) {
        alert("Không tìm thấy thông tin đặt vé. Vui lòng chọn phim lại.");
        window.location.href = 'movies.html';
        return;
    }

    const bookingData = JSON.parse(dataString);
    originalTotalAmount = bookingData.total_amount;

    // Đổ dữ liệu vào giao diện
    document.getElementById('summary-title').textContent = bookingData.movie_title || "Phim chưa xác định";
    if (bookingData.movie_image) {
        document.getElementById('summary-poster').src = bookingData.movie_image;
        document.getElementById('summary-poster').style.display = 'block';
    }

    if (bookingData.show_date) {
        document.getElementById('summary-date-time').textContent = `Ngày: ${bookingData.show_date} | Suất: ${bookingData.show_time}`;
    }
    document.getElementById('summary-booking-id').textContent = "CGV" + Math.floor(100000 + Math.random() * 900000);

    document.getElementById('summary-seat-list').textContent = bookingData.seat_labels || "Chưa chọn ghế";
    
    // Tính tiền ghế riêng để hiển thị
    const seatPriceTotal = (bookingData.seat_ids ? bookingData.seat_ids.length : 0) * 90000; 
    document.getElementById('summary-seat-total').textContent = seatPriceTotal.toLocaleString('vi-VN') + " VND";

    // Hiển thị Combo (Nếu có)
    const comboContainer = document.getElementById('combo-summary-list');
    if (comboContainer && bookingData.combos && bookingData.combos.length > 0) {
        comboContainer.innerHTML = bookingData.combos.map(c => `
            <div class="summary-item">
                <span>${c.qty} x ${c.name}</span>
                <span>${(c.qty * c.price).toLocaleString('vi-VN')} VND</span>
            </div>`).join('');
    } else {
        if(comboContainer) comboContainer.innerHTML = '';
    }

    updateTotalDisplay(originalTotalAmount);
}

// --- HÀM 2: TẢI VOUCHER TỪ API & RENDER MODAL (MỚI) ---
async function loadVoucherList() {
    try {
        const res = await fetch(`${API_BASE_URL}/vouchers/list.php`);
        allVouchers = await res.json();
        
        // Render dữ liệu vào Modal ngay sau khi tải xong
        renderVoucherModal();
    } catch (err) {
        console.error("Lỗi tải voucher:", err);
    }
}

// Hàm render HTML cho Modal
function renderVoucherModal() {
    const container = document.getElementById('voucher-list-modal');
    if (!container) return;

    if (!allVouchers || allVouchers.length === 0) {
        container.innerHTML = '<p style="text-align:center; color:#777; padding: 20px;">Không có voucher nào.</p>';
        return;
    }

    container.innerHTML = allVouchers.map(v => {
        // Kiểm tra trạng thái từ API (is_valid)
        // Nếu không hợp lệ (hết hạn) -> thêm class 'disabled' và text trạng thái
        const disabledClass = v.is_valid ? '' : 'disabled';
        const statusBadge = v.is_valid 
            ? '<span class="v-badge" style="background: #4caf50;">Dùng ngay</span>' 
            : '<span class="v-badge" style="background: #555;">Hết hạn</span>';
        
        // Sự kiện click chỉ hoạt động nếu voucher còn hạn
        const clickAction = v.is_valid ? `onclick="selectVoucher('${v.code}')"` : '';

        return `
            <div class="v-item ${disabledClass}" ${clickAction}>
                <div class="v-code">${v.code}</div>
                <div class="v-desc">${v.desc}</div>
                <div class="v-exp">HSD: ${v.exp}</div>
                ${statusBadge}
            </div>
        `;
    }).join('');
}

// --- HÀM 3: XỬ LÝ KHI NGƯỜI DÙNG CHỌN 1 VOUCHER TRONG MODAL ---
// Gán vào window để có thể gọi từ chuỗi HTML onclick
window.selectVoucher = async function(code) {
    // 1. Đóng modal
    const modal = document.getElementById('voucher-modal');
    if(modal) modal.style.display = 'none';
    
    // 2. Điền mã vào ô input hiển thị
    const inputDisplay = document.getElementById('selected-voucher-display');
    if(inputDisplay) inputDisplay.value = code;
    
    // 3. Gọi hàm kiểm tra và tính toán giảm giá
    await handleApplyVoucher(code);
};

// --- HÀM 4: CHECK VOUCHER VỚI SERVER & TÍNH TIỀN ---
async function handleApplyVoucher(code) {
    const msgEl = document.getElementById('voucher-message');
    
    if (!code) return;

    // Reset thông báo đang xử lý
    msgEl.textContent = "Đang kiểm tra...";
    msgEl.style.color = "#ccc";

    try {
        const res = await fetch(`${API_BASE_URL}/vouchers/check.php?code=${code}`);
        const data = await res.json();

        if (data.valid) {
            // --- TRƯỜNG HỢP THÀNH CÔNG ---
            msgEl.textContent = `✅ ${data.message}`;
            msgEl.style.color = '#4caf50';
            currentVoucherCode = code;
            
            // Tính toán giảm giá
            if (data.is_percent) {
                currentDiscount = originalTotalAmount * (data.discount_value / 100);
            } else {
                currentDiscount = data.discount_value;
            }

            // Hiển thị dòng giảm giá
            document.getElementById('discount-row').style.display = 'flex';
            document.getElementById('discount-amount').textContent = `-${currentDiscount.toLocaleString('vi-VN')} VND`;
            
            // Ẩn nút "Chọn mã", hiện nút "Xóa"
            const openBtn = document.getElementById('open-voucher-modal-btn');
            const removeBtn = document.getElementById('remove-voucher-btn');
            if(openBtn) openBtn.style.display = 'none';
            if(removeBtn) removeBtn.style.display = 'inline-block';

            // Cập nhật tổng tiền cuối cùng
            const finalTotal = Math.max(0, originalTotalAmount - currentDiscount);
            updateTotalDisplay(finalTotal);

        } else {
            // --- TRƯỜNG HỢP LỖI ---
            msgEl.textContent = `❌ ${data.message}`;
            msgEl.style.color = '#ff5555';
            
            // Reset về 0 nếu mã lỗi
            resetVoucherState();
        }
    } catch (err) {
        console.error(err);
        msgEl.textContent = "Lỗi kết nối server.";
    }
}

// Hàm reset trạng thái voucher (khi xóa hoặc lỗi)
function resetVoucherState() {
    currentDiscount = 0;
    currentVoucherCode = null;
    updateTotalDisplay(originalTotalAmount);
    
    document.getElementById('selected-voucher-display').value = "";
    document.getElementById('discount-row').style.display = 'none';
    
    // Đổi lại nút hiển thị
    const openBtn = document.getElementById('open-voucher-modal-btn');
    const removeBtn = document.getElementById('remove-voucher-btn');
    if(openBtn) openBtn.style.display = 'inline-block';
    if(removeBtn) removeBtn.style.display = 'none';
}

// --- HÀM 5: THIẾT LẬP SỰ KIỆN CHO MODAL ---
function setupVoucherModalEvents() {
    const modal = document.getElementById('voucher-modal');
    const openBtn = document.getElementById('open-voucher-modal-btn');
    const closeSpan = document.querySelector('.close-voucher-modal');
    const removeBtn = document.getElementById('remove-voucher-btn');

    // Mở Modal
    if(openBtn) {
        openBtn.addEventListener('click', (e) => {
            e.preventDefault(); // Ngăn submit form nếu có
            modal.style.display = "flex";
        });
    }

    // Đóng Modal (Nút X)
    if(closeSpan) {
        closeSpan.addEventListener('click', () => {
            modal.style.display = "none";
        });
    }

    // Đóng Modal (Click ra ngoài vùng trắng)
    window.addEventListener('click', (e) => {
        if(e.target == modal) {
            modal.style.display = "none";
        }
    });

    // Nút Xóa Voucher (Reset lại từ đầu)
    if(removeBtn) {
        removeBtn.addEventListener('click', (e) => {
            e.preventDefault();
            resetVoucherState();
            document.getElementById('voucher-message').textContent = "";
        });
    }
}

// --- HÀM 6: CẬP NHẬT HIỂN THỊ TỔNG TIỀN ---
function updateTotalDisplay(amount) {
    document.getElementById('summary-final-total').textContent = amount.toLocaleString('vi-VN') + " VND";
}

// --- HÀM 7: XỬ LÝ THANH TOÁN (GỬI ĐƠN HÀNG) ---
async function processRealPayment() {
    const btn = document.getElementById('confirm-payment');
    const dataString = sessionStorage.getItem('bookingDetails');
    if (!dataString) return;

    let bookingData = JSON.parse(dataString);
    const finalAmount = Math.max(0, originalTotalAmount - currentDiscount);

    // Payload gửi lên server
    const payload = {
        showtime_id: bookingData.showtime_id,
        seats: bookingData.seat_ids,
        seat_labels: bookingData.seat_labels, 
        
        customer_name: bookingData.customer_name || document.getElementById('card-name')?.value || "Khách hàng",
        customer_phone: bookingData.customer_phone || "",
        total_amount: finalAmount,
        voucher_code: currentVoucherCode || null,
        discount_amount: currentDiscount || 0
    };

    btn.disabled = true;
    btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang xử lý...';
    
    try {
        const res = await fetch(`${API_BASE_URL}/bookings/create.php`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload),
            credentials: 'include' 
        });

        const result = await res.json();

        if (res.ok) {
            document.getElementById('payment-success-modal').style.display = 'flex';
            sessionStorage.removeItem('bookingDetails');
            
            document.getElementById('back-to-home').addEventListener('click', () => window.location.href = 'index.html');
        } else {
            alert("Lỗi đặt vé: " + result.message);
            btn.disabled = false;
            btn.innerHTML = '<i class="fa-solid fa-lock"></i> Thanh Toán';
        }
    } catch (err) {
        console.error(err);
        alert("Lỗi kết nối server.");
        btn.disabled = false;
        btn.innerHTML = '<i class="fa-solid fa-lock"></i> Thanh Toán';
    }
}

// --- HÀM BỔ TRỢ: TAB ---
function setupPaymentTabs() {
    const tabs = document.querySelectorAll('.tab-btn');
    const contents = document.querySelectorAll('.tab-content');
    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            tabs.forEach(t => t.classList.remove('active'));
            contents.forEach(c => c.classList.remove('active'));
            tab.classList.add('active');
            const targetId = tab.dataset.tab;
            document.getElementById(`tab-${targetId}`).classList.add('active');
        });
    });
}

async function checkLoginStatus() { try { await fetch(`${API_BASE_URL}/auth/me.php`, { credentials: "include" }); } catch (e) {} }