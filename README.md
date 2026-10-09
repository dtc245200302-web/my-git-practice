Tổng quan bài tập
Bạn cần tạo form đăng nhập căn giữa màn hình, gồm:

Icon Bootstrap

Tiêu đề "Please sign in"

Ô nhập Email

Ô nhập Password

Checkbox "Remember me"

Nút "Sign in"

Dòng copyright

Phân tích code — tại sao nó hoạt động?
1. Căn giữa form bằng Flexbox (trong styles.css)
css
body {
    display: flex;
    align-items: center;      /* căn giữa theo chiều dọc */
    justify-content: center;  /* căn giữa theo chiều ngang */
    height: 100%;             /* cần thiết để căn giữa dọc hoạt động */
}
Đây chính là ứng dụng trực tiếp của display: flex mà bạn đã học! body được biến thành flex container, và form con được căn giữa cả 2 chiều.

Lưu ý quan trọng: html, body { height: 100%; } là bắt buộc — vì nếu body không có chiều cao cụ thể, align-items: center sẽ không có tác dụng (không có không gian để căn giữa).

2. Các class Bootstrap được dùng
Class	Ý nghĩa
text-center	Căn giữa text (tương đương text-align: center)
mb-4, mb-3, mt-5	Margin-bottom/top: 4=1.5rem, 3=1rem, 5=3rem
h3	Style heading cấp 3
font-weight-normal	Chữ thường (không đậm)
form-control	Style chuẩn cho input
btn btn-lg btn-primary	Nút lớn, màu xanh primary
btn-block	Nút chiếm full chiều rộng
text-muted	Chữ màu xám nhạt
3. "Bí quyết" tạo 2 input dính liền nhau
css
.form-signin input[type="email"] {
    margin-bottom: -1px;                    /* kéo input password lên 1px */
    border-bottom-right-radius: 0;          /* bỏ bo góc dưới */
    border-bottom-left-radius: 0;
}
.form-signin input[type="password"] {
    border-top-left-radius: 0;              /* bỏ bo góc trên */
    border-top-right-radius: 0;
}
Đây là mẹo dùng margin âm — điều mà padding không làm được (như mình đã nói ở bài Box Model). Margin âm -1px giúp 2 input dính liền không có khe hở, tạo cảm giác chúng là một khối thống nhất.

4. box-sizing: border-box cho input
css
.form-signin .form-control {
    box-sizing: border-box;   /* width bao gồm cả padding và border */
    padding: 10px;
}
Đây chính là box-sizing mà bạn đã học! Giúp input không bị "phình" kích thước khi thêm padding.

Các bước bạn cần làm
Tạo dự án WebStorm + file index.html

Thêm Bootstrap 5 qua CDN (link CSS trong <head>, script JS trước </body>)

Tải icon Bootstrap — vào https://icons.getbootstrap.com/, tải 1 icon PNG, lưu vào thư mục dự án với tên bootstrap.png

Thêm HTML form (như code trong hướng dẫn)

Tạo styles.css và link vào HTML

Chạy thử và kiểm tra kết quả

Push lên GitHub và nộp link

Một số lưu ý khi làm bài
⚠️ Về version Bootstrap: Hướng dẫn dùng Bootstrap 5.0.0-beta2 (bản beta cũ). Bạn có thể:

Giữ nguyên để khớp với bài mẫu, hoặc

Dùng bản mới nhất (5.3.x) — nhưng cần lưu ý một số class có thể đã thay đổi, ví dụ btn-block đã bị loại bỏ trong Bootstrap 5 (thay bằng w-100 hoặc d-grid)

⚠️ form-signin không phải class Bootstrap — đây là class tự đặt trong styles.css. Nhiều bạn mới học hay nhầm tưởng nó có sẵn trong Bootstrap.

⚠️ font-weight-normal cũng không phải class Bootstrap 5 chuẩn — có thể bạn cần thêm fw-normal (Bootstrap 5 dùng prefix fw-).

Câu hỏi gợi mở cho bạn
Sau khi làm xong, bạn thử trả lời mấy câu này để kiểm tra hiểu bài nhé:

Tại sao cần html, body { height: 100%; }? Nếu bỏ dòng này, form có còn căn giữa dọc không?

Nếu đổi align-items: center thành align-items: flex-start, form sẽ nằm ở đâu?

Tại sao dùng margin-bottom: -1px mà không dùng margin-bottom: 0?

Class mb-3 tương đương bao nhiêu px? (Gợi ý: Bootstrap dùng đơ
