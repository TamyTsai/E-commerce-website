import Sortable from 'sortablejs';
import Rails from "@rails/ujs";
// 從 "@rails/ujs" import Rails模組（內建的）

document.addEventListener('turbolinks:load', () => {
    let el = document.querySelector('.sortable-items');
    // 先檢查html中有沒有類別為sortable-items的元素 存在

    if (el) { //若該元素 存在
        Sortable.create(el, { //就讓 該元素 變成是 可以拖拉的
            // option、js物件
            // 拖拉放開後 會觸發onEnd事件
            onEnd: event => {
                let [model, id] = event.item.dataset.item.split('_');
                // <tr class="item" data-item="<%= dom_id(category) %>">
                // event.item 為正在被拖拉的項目
                // dataset.item 可抓到html 標籤 data-item屬性（一種dataset）對應的值
                // .split ('_')用底線分開字串 變成 不同元素 （category_1 會變成陣列中的兩個元素）
                // [model, id] 為陣列 接到 category 和 category_id

                // 組織要送到後端的資料
                let data = new FormData();
                data.append("id", id);
                // 把剛剛抓到的id 丟進剛剛新建的FormData()
                // 抓到要拖拉的資料
                data.append("from", event.oldIndex); // 其實可以不需要知道from
                data.append("to", event.newIndex);
                // 拖拉後放開會觸發onEnd事件 產生oldIndex（舊位置）與newIndex（新位置）

                // 希望用AJAX方式在背後送資料給後端 讓被拖拉的項目的新舊位置可以默默寫入資料庫
                Rails.ajax({ // 前端controller透過ajax方法，帶著data使用post方法往某一個地方（api路徑）去打，成功時...，失敗時...
                    url: '/admin/categories/sort', // 往某個地方打
                    type: 'PUT', // 用什麼方式打（html動詞）（大小寫沒差） // PUT 更新
                    data, // ES6寫法，key與value一樣，可以只寫一次
                    // data: data, // 要送出的資料（有"subscribe['email]", email的FormData()），送出後後端 就會有 一般的參數或強參數 把他抓下來
                    success: resp => { // response為透過api打後端後 後端透過api回傳的資料
                        console.log(resp);
                    },
                    error: err => { // 404、路徑找不到、伺服器發生錯誤
                        console.log(err);
                    }
                });
                // import Rails from "@rails/ujs" 的方法
                // 內建的 ujs套件
                // 可接js物件
            }
        })

    }
});