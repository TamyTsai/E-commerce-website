import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "count" ]

  updateCart(evt) {
    let data = evt.detail; // 將 product_controller.js所發佈的自訂事件 的 datail（hash）指定給data
    //  product_controller.js自訂要發佈的事件：let evt = new CustomEvent('addToCart', { 'detail': { item_count } }); 
    this.countTarget.innerText = `（${data.item_count}）`; // 抓到data（datail（hash））item_count key所對應的value，改變view 購物車旁顯示的數字    
  }
}