
//= require_directory .
//= require bulma-carousel/dist/js/bulma-carousel.min.js

// Bulma跑馬燈js
document.addEventListener('DOMContentLoaded', () => { // ES6箭頭函式寫法 // Rails 6 中Turbo links預設為開啟 所以如果用 DOMContentLoaded 可能沒辦法間聽到正確之事件，要改用turbolinks:load
    let element = document.querySelector('#carousel');

    if (element) { // 若 id 為 carousel 的html元素 「存在」的話
        bulmaCarousel.attach('#carousel', {
            slidesToScroll: 1,
            slidesToShow: 3, // 一次顯示幾張圖
            infinite: true,  // 開啟 無限捲軸
            autoplay: true  // 開啟 自動播放
        });
    }
});