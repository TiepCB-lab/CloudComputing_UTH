const API_BASE_URL = "/backend/api";
const SEAT_PRICE = 90000; 

// --- DỮ LIỆU COMBO (Giả lập vì chưa có database bảng Combo) ---
const COMBO_MENU = [
    { id: 'c1', name: "Combo Solo (1 Bắp + 1 Nước)", price: 79000, img: "assets/images/popcorn.png" },
    { id: 'c2', name: "Combo Couple (1 Bắp + 2 Nước)", price: 99000, img: "assets/images/popcorn.png" },
    { id: 'c3', name: "Combo Family (2 Bắp + 4 Nước)", price: 189000, img: "assets/images/popcorn.png" }
];

let selectedSeats = [];
let selectedShowtimeId = null;
let bookedSeatsList = []; 
let currentMovieId = null;
let selectedCombos = {}; // Lưu trữ combo: { 'c1': 2, 'c2': 0 }

document.addEventListener('DOMContentLoaded', async () => {
    await checkLoginStatus(); 
    addHeaderScrollEffect();
    setupUserMenuListeners();

    const params = new URLSearchParams(window.location.search);
    currentMovieId = params.get('id');
    
    if (!currentMovieId) { alert("Chưa chọn phim!"); window.location.href="index.html"; return; }

    initializeBookingPage(currentMovieId);
});

async function initializeBookingPage(movieId) {
    await loadMovieInfo(movieId);
    generateDateSelector(movieId);
    
    // ⭐ KHỞI TẠO DANH SÁCH COMBO ⭐
    renderComboMenu();

    const btnConfirm = document.getElementById('confirm-booking');
    if(btnConfirm) {
        const newBtn = btnConfirm.cloneNode(true);
        btnConfirm.parentNode.replaceChild(newBtn, btnConfirm);
        newBtn.addEventListener('click', confirmBooking);
    }
}

// --- 1. RENDER DANH SÁCH COMBO ---
function renderComboMenu() {
    const container = document.getElementById('combo-list-container');
    if (!container) return;
    container.innerHTML = '';

    COMBO_MENU.forEach(item => {
        // Mặc định số lượng là 0
        selectedCombos[item.id] = 0; 

        const div = document.createElement('div');
        div.className = 'combo-item';
        div.innerHTML = `
            <img src="bapnuoc.jpg" alt="Combo">
            <div class="combo-info">
                <h4>${item.name}</h4>
                <p>${item.price.toLocaleString('vi-VN')} VND</p>
            </div>
            <div class="combo-quantity-selector">
                <button class="quantity-btn minus" data-id="${item.id}">-</button>
                <span class="quantity-display" id="qty-${item.id}">0</span>
                <button class="quantity-btn plus" data-id="${item.id}">+</button>
            </div>
        `;
        container.appendChild(div);
    });

    // Gán sự kiện tăng giảm
    document.querySelectorAll('.quantity-btn.plus').forEach(btn => {
        btn.addEventListener('click', () => updateComboQuantity(btn.dataset.id, 1));
    });
    document.querySelectorAll('.quantity-btn.minus').forEach(btn => {
        btn.addEventListener('click', () => updateComboQuantity(btn.dataset.id, -1));
    });
}

function updateComboQuantity(id, change) {
    if (selectedCombos[id] + change < 0) return; // Không cho âm
    selectedCombos[id] += change;

    // Cập nhật số trên giao diện
    document.getElementById(`qty-${id}`).textContent = selectedCombos[id];
    
    // Tính lại tổng tiền
    updateSummary();
}

// --- CÁC HÀM CŨ (Giữ nguyên logic, chỉ sửa updateSummary) ---

async function loadMovieInfo(movieId) {
    try {
        const res = await fetch(`${API_BASE_URL}/movies/detail.php?id=${movieId}`);
        if (!res.ok) return;
        const movie = await res.json();
        document.getElementById('movie-title').textContent = movie.title;
        document.getElementById('movie-poster').src = movie.imageUrl;
        document.getElementById('movie-poster').style.display = 'block';
        document.getElementById('movie-year-rating').textContent = `Năm: ${movie.year} | Rating: ${movie.rating}`;
        document.getElementById('movie-duration-genre').textContent = `Thời lượng: ${movie.duration} | Thể loại: ${movie.genre}`;
    } catch (err) {}
}

function generateDateSelector(movieId) {
    const container = document.getElementById('date-selector');
    container.innerHTML = '';
    const today = new Date(); 
    for (let i = 0; i < 7; i++) {
        const date = new Date(today);
        date.setDate(today.getDate() + i);
        const apiDate = date.toISOString().split('T')[0];
        const displayDate = `${date.getDate()}/${date.getMonth() + 1}`;
        const dayName = i === 0 ? "Hôm nay" : `Thứ ${date.getDay() + 1 === 1 ? 'CN' : date.getDay() + 1}`;
        const btn = document.createElement('div');
        btn.className = 'date-item';
        if (i === 0) btn.classList.add('selected');
        btn.innerHTML = `<div>${dayName}</div><div style="font-size:1.2rem; font-weight:bold">${displayDate}</div>`;
        btn.addEventListener('click', () => {
            document.querySelectorAll('.date-item').forEach(el => el.classList.remove('selected'));
            btn.classList.add('selected');
            loadShowtimes(movieId, apiDate);
        });
        container.appendChild(btn);
    }
    const todayApi = today.toISOString().split('T')[0];
    loadShowtimes(movieId, todayApi);
}

async function loadShowtimes(movieId, date) {
    const container = document.getElementById('showtime-selector');
    container.innerHTML = '<p>Đang tìm suất chiếu...</p>';
    document.getElementById('seat-map').innerHTML = 'Vui lòng chọn suất chiếu.';
    selectedShowtimeId = null;
    selectedSeats = [];
    // Reset combo về 0 khi đổi ngày cho an toàn (hoặc giữ nguyên tùy bạn)
    updateSummary();

    try {
        const res = await fetch(`${API_BASE_URL}/showtimes/list.php?movie_id=${movieId}&date=${date}`);
        const showtimes = await res.json();
        container.innerHTML = '';
        if (!showtimes || showtimes.length === 0) {
            container.innerHTML = '<p style="color: #ff5555; font-style: italic;">Không có suất chiếu nào.</p>';
            return;
        }
        showtimes.forEach(st => {
            const btn = document.createElement('div');
            btn.className = 'time-item';
            btn.textContent = `${st.show_time}`; 
            btn.addEventListener('click', () => {
                document.querySelectorAll('.time-item').forEach(el => el.classList.remove('selected'));
                btn.classList.add('selected');
                selectedShowtimeId = st.id;
                loadBookedSeats(st.id);
            });
            container.appendChild(btn);
        });
    } catch (err) { container.innerHTML = 'Lỗi tải suất chiếu'; }
}

async function loadBookedSeats(showtimeId) {
    const mapContainer = document.getElementById('seat-map');
    mapContainer.innerHTML = '<p style="color:white">Đang cập nhật sơ đồ...</p>';
    try {
        const res = await fetch(`${API_BASE_URL}/showtimes/booked_seats.php?id=${showtimeId}`);
        bookedSeatsList = await res.json(); 
        renderSeatMap();
    } catch (err) {}
}

function renderSeatMap() {
    const container = document.getElementById('seat-map');
    container.innerHTML = ''; 
    selectedSeats = [];
    updateSummary();
    const rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
    const cols = 12; 
    let currentSeatId = 1;
    rows.forEach((rowName) => {
        for (let i = 1; i <= cols; i++) {
            const seatDiv = document.createElement('div');
            const isBooked = bookedSeatsList.includes(currentSeatId);
            seatDiv.className = isBooked ? 'seat booked' : 'seat available';
            seatDiv.textContent = rowName + i;
            seatDiv.dataset.id = currentSeatId;
            seatDiv.dataset.label = rowName + i;
            if (isBooked) seatDiv.title = "Đã có người đặt";
            else {
                seatDiv.addEventListener('click', function() {
                    this.classList.toggle('selected');
                    handleSeatSelect(parseInt(this.dataset.id), this.dataset.label);
                });
            }
            container.appendChild(seatDiv);
            currentSeatId++;
        }
    });
}

function handleSeatSelect(id, label) {
    const index = selectedSeats.findIndex(s => s.id === id);
    if (index > -1) selectedSeats.splice(index, 1);
    else selectedSeats.push({ id, label });
    updateSummary();
}

// ⭐ 2. CẬP NHẬT HÀM TÍNH TỔNG TIỀN (BAO GỒM CẢ COMBO) ⭐
function updateSummary() {
    // 1. Tính tiền vé
    const seatTotal = selectedSeats.length * SEAT_PRICE;
    
    // 2. Tính tiền Combo
    let comboTotal = 0;
    let comboSummaryHtml = '';
    
    COMBO_MENU.forEach(item => {
        const qty = selectedCombos[item.id] || 0;
        if (qty > 0) {
            comboTotal += qty * item.price;
            comboSummaryHtml += `
                <div class="summary-item">
                    <span>${qty} x ${item.name}</span>
                    <span>${(qty * item.price).toLocaleString('vi-VN')} đ</span>
                </div>
            `;
        }
    });

    // 3. Cập nhật giao diện cột phải
    const list = document.getElementById('selected-list');
    const seatTotalEl = document.getElementById('selected-seats-total');
    const comboListEl = document.getElementById('combo-summary-list');
    const totalPriceEl = document.getElementById('total-price');

    // Hiển thị ghế
    if(selectedSeats.length === 0) {
        list.textContent = "(chưa chọn)";
        seatTotalEl.textContent = "0 VND";
    } else {
        list.textContent = selectedSeats.map(s => s.label).join(', ');
        seatTotalEl.textContent = seatTotal.toLocaleString('vi-VN') + " VND";
    }

    // Hiển thị combo
    if (comboListEl) comboListEl.innerHTML = comboSummaryHtml;

    // Hiển thị Tổng cộng
    const finalTotal = seatTotal + comboTotal;
    totalPriceEl.textContent = finalTotal.toLocaleString('vi-VN') + " VND";
    
    // Lưu giá trị tổng để dùng khi bấm tiếp tục
    totalPriceEl.dataset.value = finalTotal;
}

function confirmBooking() {
    if (!selectedShowtimeId) { alert("Vui lòng chọn suất chiếu!"); return; }
    if (selectedSeats.length === 0) { alert("Vui lòng chọn ghế!"); return; }

    const custNameInput = document.getElementById('cust-name');
    const custPhoneInput = document.getElementById('cust-phone');
    const custName = custNameInput.value.trim();
    const custPhone = custPhoneInput.value.trim();

    if (!custName) { alert("Vui lòng nhập Họ và tên!"); custNameInput.focus(); return; }
    if (!custPhone) { alert("Vui lòng nhập SĐT!"); custPhoneInput.focus(); return; }

    // Lấy tổng tiền từ giao diện (đã tính cả combo)
    const rawTotal = document.getElementById('total-price').dataset.value;
    const finalTotal = parseInt(rawTotal) || 0;

    // Lấy chi tiết combo để hiển thị bên trang Payment
    const comboDetails = [];
    COMBO_MENU.forEach(item => {
        if (selectedCombos[item.id] > 0) {
            comboDetails.push({ 
                name: item.name, 
                qty: selectedCombos[item.id], 
                price: item.price 
            });
        }
    });

    const bookingData = {
        showtime_id: selectedShowtimeId, 
        seat_ids: selectedSeats.map(s => s.id),
        seat_labels: selectedSeats.map(s => s.label).join(', '),
        total_amount: finalTotal, // Tổng tiền đã bao gồm Combo
        
        movie_title: document.getElementById('movie-title').textContent,
        movie_image: document.getElementById('movie-poster').src,
        show_date: document.querySelector('.date-item.selected div:nth-child(2)')?.textContent,
        show_time: document.querySelector('.time-item.selected')?.textContent,

        customer_name: custName,
        customer_phone: custPhone,
        
        // ⭐ Truyền thêm combo sang trang Payment
        combos: comboDetails 
    };

    sessionStorage.setItem('bookingDetails', JSON.stringify(bookingData));
    window.location.href = 'payment.html';
}

// Helpers (Giữ nguyên)
async function checkLoginStatus() {
    try {
        const res = await fetch(`${API_BASE_URL}/auth/me.php`, { credentials: "include" });
        const data = await res.json();
        updateHeaderUI(res.ok ? data.username : null);
    } catch (e) {}
}
function updateHeaderUI(username) {
    const btn = document.getElementById("user-menu-btn");
    const dropdown = document.getElementById("user-dropdown");
    if (username) {
        btn.innerHTML = `<i class="fa-solid fa-user"></i> ${username}`;
        dropdown.innerHTML = `<a href="profile.html">Tài khoản</a><a href="#" id="logout-btn">Đăng xuất</a>`;
        setTimeout(() => { document.getElementById('logout-btn')?.addEventListener('click', async (e)=>{ e.preventDefault(); await fetch(`${API_BASE_URL}/auth/logout.php`, {credentials:"include"}); window.location.href="index.html"; })}, 500);
    } else {
        btn.innerHTML = `<i class="fa-solid fa-user"></i>`;
        dropdown.innerHTML = `<a href="login.html">Đăng nhập</a><a href="register.html">Đăng kí</a>`;
    }
}
function addHeaderScrollEffect() { const h=document.querySelector('.main-header'); if(h) window.addEventListener('scroll', ()=>h.classList.toggle('scrolled', window.scrollY>50)); }
function setupUserMenuListeners() {
    const btn = document.getElementById('user-menu-btn');
    const dropdown = document.getElementById('user-dropdown');
    if(btn) btn.addEventListener('click', (e) => { e.stopPropagation(); dropdown.classList.toggle('active'); });
    window.addEventListener('click', () => dropdown?.classList.remove('active'));
}