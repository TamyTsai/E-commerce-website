import { Controller } from "stimulus"

export default class extends Controller {
    static targets = [ "quantity" ]

    quantity_minus(evt) {
        evt.preventDefault();
        if (q > 1) { // 至少要買一個商品，所以商品數量大於1時，-按鈕才有作用
            this.quantityTarget.value = q - 1;
        }
    }

    quantity_plus(evt) {
        evt.preventDefault();
        let q = Number(this.quantityTarget.value);
        // 抓到data-target屬性值為product.quantity的html輸入框標籤後，將其輸入框之值 轉換為數字
        // q 為輸入框之值（數字）
        this.quantityTarget.value = q + 1;
    }


    // 確定有連到view用的
    // connect() {
    //     console.log('hi');
    // }

    
}