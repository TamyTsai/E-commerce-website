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
        // 到時候傳過去的東西會像是 Parameters: {"subscribe"=>{"email"=>"aaa@ccc.com"}}
        // hash 中有個 subscribe key, value為另一個key email，vaule為aaa@ccc.com
        // 所以也可以只寫 data.append("email", email);
        // 就變成 Parameters: {"subscribe"=>"aaa@ccc.com"}
        // 但原寫法為Rails慣例 給eamil套個主題

        Rails.ajax({ // 前端controller透過ajax方法，帶著data使用post方法往某一個地方（api路徑）去打，成功時...，失敗時...
            url: '/api/v1/subscribe', // 往某個地方打
            data, // ES6寫法，key與value一樣，可以只寫一次
            // data: data, // 要送出的資料（有"subscribe['email]", email的FormData()），送出後後端 就會有 一般的參數或強參數 把他抓下來
            type: 'POST', // 用什麼方式打（html動詞）（大小寫沒差）
            dataType: 'json', // 希望伺服器回傳 json格式之檔案回來
            success: (response)=> { // response為透過api打後端後 後端透過api回傳的資料
                switch (response.status){ // 後端回一包json檔案 抓出其中的 status key
                    case 'ok': // status key 之 value 若等於 ok（表示email寫入資料庫成功）
                        alert('完成訂閱');
                        this.emailTarget.value = "";
                        // 抓到data-target="subscribe.email"的html元素輸入框中的值，將其變成空白（完成訂閱後 清空輸入框）
                        // this指的是這個function本身 所以會失敗，要把function改成ES6 箭頭函數，這樣作用scope就會不一樣
                        break;
                    case '已訂閱過電子報': // status key 之 value 若等於 已訂閱過電子報（表示email寫入資料庫失敗）
                        alert(`${response.email} 已訂閱過電子報`); // 後端回一包json檔案 抓出其中的 email key
                        // 後端controller： render json: { status: '已訂閱過電子報', email: email }
                        break;
                }
            },
            error: function(err) { // 404、路徑找不到、伺服器發生錯誤
                console.log(err);
            }
        });
        // import Rails from "@rails/ujs" 的方法
        // 內建的 ujs套件
        // 可接js物件

    }

    // 連上controller就會自動做的事
    // connect(){
    //     console.log('ok');
    // }
}