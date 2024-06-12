import Sortable from 'sortablejs';

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
                console.log(model, id);
            }
        })

    }
});