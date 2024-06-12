import { Controller } from "stimulus"

export default class extends Controller {
    static targets = ["template", "link"]

    add_sku(event) {
        event.preventDefault(); // 把預設的行為檔下來（連結# 跑到畫面最上面）

        let content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime());
        // 抓出data-target屬性 值為"product-form.template"的 html元素（準備被新增的輸入框）
        // html中 child_index: 'NEW_RECORD'
        // .replace(/NEW_RECORD/g, new Date().getTime()) ： 希望NEW_RECORD被換成一個uniq的標記（時間），把NEW_RECORD 換成一個 像時間序號的東西（時間戳記）
        // 序號相同的話 寫進資料庫就會覆蓋序號相同的舊資料 到時候就只能新增一次輸入框 後面新增的都會一直取代前面的 所以才要給一個唯一的序號
        // /NEW_RECORD/ 常規表示法 （讓replace知道要抓這個字樣）
        this.linkTarget.insertAdjacentHTML('beforebegin', content);
        // this.linkTarget：新增品項按鈕
        // .insertAdjacentHTML('beforebegin', content)：在 元素自己本身 前面 再安插一HTML元素（content）
        // 如此一來 當 新增品項（data action add_sku）被按下後，救會長出新的輸入框
        console.log(content);
    }

    remove_sku(event) {
        event.preventDefault();

        let wrapper = event.target.closest('.nested-fields');
        // 抓到離 刪除 按鈕 最近的html元素（類別為 nested-fields 的html元素）（sku輸入框）
        if (wrapper.dataset.newRecord == 'true' ) { // 如果該sku是新的 輸入框中的欄位尚未寫進資料庫  // data-new-record="<%= form.object.new_record? %>" -> newRecord
            wrapper.remove(); // 就直接移除 輸入框 html元素 即可
        }
        else { // 如果該sku是舊的 輸入框中的欄位先前已寫進資料庫 
            wrapper.querySelector("input[name*='_destroy']").value = 1;
            // 抓到輸入框 name為_destroy 的html元素？，將其值 設定為 1
            // _destroy欄位被設定為1後，按下送出（update product按鈕）後，送進後端資料庫，對應的sku資料就會被刪除
            wrapper.style.display = 'none';
            // 在畫面上隱藏 但其實還在
            // 不用.remove()，因為用了會 移除整個html元素（<%= form.hidden_field :_destroy %>）
        }
    }
}