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

    connect() {
       
    }
}