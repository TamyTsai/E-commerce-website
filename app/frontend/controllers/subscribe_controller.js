import { Controller } from "stimulus";
import Rails from "@rails/ujs";
// 從 "@rails/ujs" import Rails模組

export default class extends Controller {
    static targets = [ "email" ]

    add(event) {
        event.preventDefault();

        let email = this.emailTarget.value.trim();
        // 抓到data-target="subscribe.email"的html元素輸入框中的值
        // .trim()修剪頭尾空白（使用者不小心輸入的無意義空白）
        let data = new FormData();
        // 準備一包FormData()
        data.append("subscribe[email]", email);
        // 把"subscribe['email']", email 丟進剛剛新建的FormData()


        Rails.ajax({
            url: '/api/v1/subscribe', // 往某個地方打
            type: 'POST', // 用什麼方式打（html動詞）（大小寫沒差）
            dataType: 'json', // 希望伺服器回傳 json格式之檔案回來
            // data: data, // 要送出的資料（有"subscribe['email]", email的FormData()），送出後後端 就會有 一般的參數或強參數 把他抓下來
            data // ES6寫法，key與value一樣，可以只寫一次
        })
        // import Rails from "@rails/ujs" 的方法
        // 內建的 ujs套件
        // 可接js物件

    }

    // 連上controller就會自動做的事
    // connect(){
    //     console.log('ok');
    // }
}