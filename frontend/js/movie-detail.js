const API_BASE_URL = "/backend/api";

document.addEventListener("DOMContentLoaded", async () => {
    try {
        await Promise.all([
            loadComponent("#header-placeholder", "components/header.html"),
            loadComponent("#footer-placeholder", "components/footer.html"),
            loadComponent("#modal-placeholder", "components/modal-trailer.html")
        ]);
        await checkLoginStatus();
        addHeaderScrollEffect();
        setupModalListeners();
        setupUserMenuListeners();
        setupHeaderSearchListeners();

        await loadMovieData();
    } catch (e) { console.error(e); }
});

async function loadMovieData() {
    const urlParams = new URLSearchParams(window.location.search);
    const movieId = urlParams.get('id');

    if (!movieId) return;

    try {
        const res = await fetch(`${API_BASE_URL}/movies/detail.php?id=${movieId}`);
        if (!res.ok) return;

        const movie = await res.json();
        if(movie) populateDetailPage(movie);

    } catch (err) { console.error(err); }
}

function populateDetailPage(movie) {
    document.title = `${movie.title} - Web Xem Phim`;
    
    // Ảnh nền & Poster
    const backdropUrl = movie.bannerUrl || movie.imageUrl;
    if (backdropUrl) document.querySelector(".detail-backdrop").style.backgroundImage = `url(${backdropUrl})`;
    document.getElementById("detail-poster-img").src = movie.imageUrl;
    
    // Thông tin chính
    document.getElementById("detail-title").textContent = movie.title;
    document.getElementById("detail-description").textContent = movie.description || "Đang cập nhật...";
    
    // Nút chức năng
    const trailerBtn = document.getElementById("detail-trailer-btn");
    if(trailerBtn) trailerBtn.dataset.trailerUrl = movie.trailerUrl;

    const bookBtn = document.querySelector('.detail-actions .btn-primary');
    if (bookBtn) bookBtn.onclick = () => window.location.href = `booking.html?id=${movie.id}`;

    // Thông tin phụ
    if(document.getElementById("detail-year")) document.getElementById("detail-year").textContent = movie.year;
    if(document.getElementById("detail-duration")) document.getElementById("detail-duration").textContent = movie.duration;
    if(document.getElementById("detail-rating")) document.getElementById("detail-rating").textContent = movie.rating || "T13";
    if(document.getElementById("detail-genre")) document.getElementById("detail-genre").textContent = movie.genre;

    // ⭐ ĐÂY LÀ PHẦN QUAN TRỌNG BẠN ĐANG THIẾU ⭐
    // Cập nhật Đạo diễn và Diễn viên lên giao diện
    if(document.getElementById("detail-director")) {
        document.getElementById("detail-director").textContent = movie.director || "Đang cập nhật";
    }
    if(document.getElementById("detail-cast")) {
        document.getElementById("detail-cast").textContent = movie.cast || "Đang cập nhật";
    }
}

// --- Helper Functions ---
async function loadComponent(id, url) { try { document.querySelector(id).innerHTML = await (await fetch(url)).text(); } catch(e){} }
async function checkLoginStatus() { try { const res = await fetch(`${API_BASE_URL}/auth/me.php`, {credentials:"include"}); const data=await res.json(); updateHeaderUI(res.ok?data.username:null); } catch(e){} }
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
function setupModalListeners() { 
    const modal = document.getElementById("trailer-modal");
    const iframe = document.getElementById("trailer-iframe");
    const closeBtn = document.getElementById("modal-close-btn");
    if(!modal) return;
    document.body.addEventListener("click", e => {
        const btn = e.target.closest(".btn-open-modal");
        if(btn) { iframe.src = `${btn.dataset.trailerUrl}?autoplay=1`; modal.classList.add("active"); }
    });
    closeBtn?.addEventListener("click", ()=>{ modal.classList.remove("active"); iframe.src=""; });
}
function setupUserMenuListeners() {
    const btn = document.getElementById('user-menu-btn');
    const dropdown = document.getElementById('user-dropdown');
    if(btn) btn.addEventListener('click', (e) => { e.stopPropagation(); dropdown.classList.toggle('active'); });
    window.addEventListener('click', () => dropdown?.classList.remove('active'));
}
function setupHeaderSearchListeners() {
    const input = document.getElementById('header-search-input');
    const btn = document.getElementById('header-search-btn');
    if(!input) return;
    const doSearch = () => { const q = input.value.trim(); window.location.href = q ? `movies.html?q=${encodeURIComponent(q)}` : "movies.html"; };
    input.addEventListener('keydown', e => e.key === 'Enter' && doSearch());
    btn.addEventListener('click', doSearch);
}