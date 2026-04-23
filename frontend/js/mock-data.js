// Dữ liệu giả lập (Đã cập nhật đầy đủ thông tin chi tiết)
const mockData = {
    // Banner: Phim Mưa Đỏ (2025)
    banner: {
        id: 99,
        title: "Mưa Đỏ",
        year: 2025,
        description: "Lấy bối cảnh 81 ngày đêm khốc liệt tại Thành Cổ Quảng Trị năm 1972, Mưa Đỏ là câu chuyện hư cấu, theo chân một tiểu đội gồm những người lính trẻ tuổi, đầy nhiệt huyết, chiến đấu và bám trụ tại trận địa lịch sử này.",
        imageUrl: "https://imgchinhsachcuocsong.vnanet.vn/MediaUpload/Org/2025/07/23/204219-z6833331728306_9920591c2fadf96b8ec838e4967f44a4.jpg", 
        trailerUrl: "https://www.youtube.com/embed/BD6PoZJdt_M",
        // Dữ liệu mới
        duration: "120 phút",
        rating: "T18",
        genre: "Chiến tranh, Lịch sử",
        director: "Nguyễn Quang Dũng",
        cast: "Nhiều diễn viên trẻ"
    },
    
    // 5 Phim Mới / Hot (2024-2025)
    newMovies: [
        {
            id: 1,
            title: "Lật Mặt 7: Một Điều Ước",
            year: 2024,
            description: "Phim xoay quanh câu chuyện của bà Hai (Thanh Hiền) và bốn người con. Khi bà Hai không may gặp nạn, cần người chăm sóc, bốn người con đùn đẩy nhau. Câu chuyện đặt ra câu hỏi về lòng hiếu thảo và tình cảm gia đình.",
            imageUrl: "https://photo-baomoi.bmcdn.me/w700_r1/2024_03_13_17_48553023/057ac6914bdda283fbcc.jpg",
            trailerUrl: "https://www.youtube.com/embed/d1ZHdosjNX8",
            // Dữ liệu mới
            duration: "138 phút",
            rating: "T13",
            genre: "Gia đình, Chính kịch",
            director: "Lý Hải",
            cast: "Thanh Hiền, Trương Minh Cường, Đinh Y Nhung, Quách Ngọc Tuyên"
        },
        {
            id: 2,
            title: "Gặp Lại Chị Bầu",
            year: 2024,
            description: "Phúc, một thanh niên có quá khứ bất hảo, cùng bạn bè lập nghiệp ở xóm trọ. Anh gặp Huyền, một cô gái tốt bụng. Tình yêu của họ nảy nở giữa những khó khăn, và bí mật về quá khứ của Huyền dần được hé lộ.",
            imageUrl: "https://tse3.mm.bing.net/th/id/OIP.xrGKhbdzKrWVQ2urtnnk-AHaK_?rs=1&pid=ImgDetMain&o=7&rm=3",
            trailerUrl: "https://www.youtube.com/embed/8WS_CiekZLc",
            // Dữ liệu mới
            duration: "110 phút",
            rating: "T16",
            genre: "Hài, Tình cảm",
            director: "Nhất Trung",
            cast: "Anh Tú, Diệu Nhi, Lê Giang, Ngọc Phước"
        },
        {
            id: 3,
            title: "Nhà Gia Tiên",
            year: 2025,
            description: "Câu chuyện về một gia đình gốc Việt tại Mỹ và những xung đột thế hệ. Phim khám phá sự khác biệt văn hóa, kỳ vọng của cha mẹ và ước mơ của con cái trong bối cảnh hiện đại.",
            imageUrl: "https://st.download.com.vn/data/image/2025/02/14/nha-gia-tien.jpg",
            trailerUrl: "https://www.youtube.com/embed/aR2lnpCLqUk",
            // Dữ liệu mới
            duration: "95 phút",
            rating: "T13",
            genre: "Gia đình, Hài",
            director: "Trần Hữu Tấn",
            cast: "Lê Khanh, Hồng Đào, Thái Hòa, Tuấn Trần"
        },
        {
            id: 4,
            title: "Thám Tử Kiên: Kỳ Án Không Đầu",
            year: 2025,
            description: "Một thám tử tư tài ba nhưng lập dị điều tra một vụ án mạng bí ẩn nơi nạn nhân bị mất đầu. Anh phải chạy đua với thời gian để tìm ra hung thủ trước khi hắn ra tay lần nữa.",
            imageUrl: "https://tse1.mm.bing.net/th/id/OIP.4HedOsPiqdgGJBNfuEHYUQHaKl?rs=1&pid=ImgDetMain&o=7&rm=3",
            trailerUrl: "https://www.youtube.com/embed/QiXNbEKF3U0",
            // Dữ liệu mới
            duration: "115 phút",
            rating: "T18",
            genre: "Trinh thám, Kinh dị",
            director: "Victor Vũ",
            cast: "Hứa Vĩ Văn, Trúc Anh, Kaity Nguyễn"
        },
        {
            id: 5,
            title: "Nhà Bà Nữ",
            year: 2023,
            description: "Phim xoay quanh gia đình bà Nữ, chủ một quán bánh canh cua, và những mâu thuẫn thế hệ gay gắt. Câu chuyện khai thác áp lực gia đình, tình yêu và sự tha thứ.",
            imageUrl: "https://th.bing.com/th/id/R.4484bb72cef55c45590763e3d98772ed?rik=KN1P4v1nfCF6sA&pid=ImgRaw&r=0",
            trailerUrl: "https://www.youtube.com/embed/4peQFKutH34",
            // Dữ liệu mới
            duration: "135 phút",
            rating: "T16",
            genre: "Chính kịch, Gia đình",
            director: "Trấn Thành",
            cast: "Trấn Thành, Lê Giang, Uyển Ân, Song Luân"
        }
    ],

    // 5 Phim Thịnh Hành (2022-2023)
    trendingMovies: [
        {
            id: 6,
            title: "Lật Mặt 6: Tấm Vé Định Mệnh",
            year: 2023,
            description: "Một nhóm bạn thân trúng số độc đắc. Tấm vé đã thay đổi cuộc đời họ, nhưng cũng kéo theo những âm mưu, sự phản bội và cái chết. Tình bạn của họ bị thử thách bởi lòng tham.",
            imageUrl: "https://tse3.mm.bing.net/th/id/OIP.gwUCRkCrlItYPT7oEALsKAHaLH?rs=1&pid=ImgDetMain&o=7&rm=3",
            trailerUrl: "https://www.youtube.com/embed/ns9f92mR6bM",
            // Dữ liệu mới
            duration: "132 phút",
            rating: "T18",
            genre: "Hành động, Giật gân",
            director: "Lý Hải",
            cast: "Quốc Cường, Trung Dũng, Huy Khánh, Thanh Thức"
        },
        {
            id: 7,
            title: "Đất Rừng Phương Nam",
            year: 2023,
            description: "Phiên bản điện ảnh kể về hành trình phiêu lưu của cậu bé An đi tìm cha qua các tỉnh miền Tây Nam Bộ trong thời kỳ kháng chiến chống Pháp. Phim tái hiện vẻ đẹp hùng vĩ của thiên nhiên và con người nơi đây.",
            imageUrl: "https://tse1.mm.bing.net/th/id/OIP.fAgqmbugm7Fvfh9qY37GkwHaJQ?rs=1&pid=ImgDetMain&o=7&rm=3",
            trailerUrl: "https://www.youtube.com/embed/D0_w81Q-P3M",
            // Dữ liệu mới
            duration: "110 phút",
            rating: "T13",
            genre: "Phiêu lưu, Gia đình",
            director: "Nguyễn Quang Dũng",
            cast: "Hạo Khang, Trấn Thành, Tuấn Trần, Hồng Ánh"
        },
        {
            id: 8,
            title: "Em và Trịnh",
            year: 2022,
            description: "Bộ phim tái hiện cuộc đời và những mối tình của nhạc sĩ Trịnh Công Sơn. Phim là bức tranh lãng mạn về âm nhạc, tình yêu và những nàng thơ đã đi qua cuộc đời ông.",
            imageUrl: "https://tintuc-divineshop.cdn.vccloud.vn/wp-content/uploads/2022/06/review-em-va-trinh_62a329726ea9a.jpeg",
            trailerUrl: "https://www.youtube.com/embed/zzik4JB9D1Q",
            // Dữ liệu mới
            duration: "136 phút",
            rating: "T13",
            genre: "Tiểu sử, Lãng mạn",
            director: "Phan Gia Nhật Linh",
            cast: "Avin Lu, Bùi Lan Hương, Hoàng Hà, Lan Thy"
        },
        {
            id: 9,
            title: "Con Nhót Mót Chồng",
            year: 2023,
            description: "Câu chuyện hài hước và cảm động về Nhót, một người phụ nữ 'quá lứa' sống cùng người cha nghiện rượu. Hành trình tìm chồng của Nhót cũng là hành trình cô hàn gắn tình cảm với cha mình.",
            imageUrl: "https://tse1.explicit.bing.net/th/id/OIP.ycZsFjfDFuRrzw-EGbeosAHaJQ?rs=1&pid=ImgDetMain&o=7&rm=3",
            trailerUrl: "https://www.youtube.com/embed/e7KHOQ-alqY",
            // Dữ liệu mới
            duration: "90 phút",
            rating: "T16",
            genre: "Hài, Gia đình",
            director: "Vũ Ngọc Đãng",
            cast: "Thu Trang, Thái Hòa, Tiến Luật"
        },
        {
            id: 10,
            title: "Siêu Lừa Gặp Siêu Lầy",
            year: 2023,
            description: "Khoa, một tên lừa đảo, đến Phú Quốc với ý định lừa đảo. Anh gặp Tú, một tên lừa đảo 'lầy lội' khác. Cả hai hợp tác trong nhiều phi vụ dở khóc dở cười trước khi đối mặt với một đối thủ lớn.",
            imageUrl: "https://tse1.mm.bing.net/th/id/OIP.wqDOC6JOXfblf2BIRrMLlQHaK4?rs=1&pid=ImgDetMain&o=7&rm=3",
            trailerUrl: "https://www.youtube.com/embed/oNqD2HxBUq4",
            // Dữ liệu mới
            duration: "112 phút",
            rating: "T16",
            genre: "Hài, Hành động",
            director: "Võ Thanh Hòa",
            cast: "Anh Tú, Mạc Văn Khoa, Ngọc Phước"
        }
    ]
};