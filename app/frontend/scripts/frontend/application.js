// 全站（前台）都會用到的js 放在此

// Bulma跑馬燈js
import bulmaCarousel from 'bulma-carousel';
// 從bulma-carousel import bulmaCarousel 出來

document.addEventListener('turbolink:load', () => { // ES6箭頭函式寫法
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
