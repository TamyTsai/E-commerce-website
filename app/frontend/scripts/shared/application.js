// 前後台共用之js

// Bulma漢堡選單js
// https://bulma.io/documentation/components/navbar/
document.addEventListener('turbolinks:load', () => { // Rails 6 中Turbo links預設為開啟 所以如果用 DOMContentLoaded 可能沒辦法間聽到正確之事件，要改用turbolinks:load

    // Get all "navbar-burger" elements
    const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);
  
    // Add a click event on each of them
    $navbarBurgers.forEach( el => {
      el.addEventListener('click', () => {
  
        // Get the target from the "data-target" attribute
        const target = el.dataset.target;
        const $target = document.getElementById(target);
  
        // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
        el.classList.toggle('is-active');
        $target.classList.toggle('is-active');
  
      });
    });
  
  });

  // 提醒視窗叉叉功能
  document.addEventListener('turbolinks:load', () => {
    (document.querySelectorAll('.notification .delete') || []).forEach(($delete) => {
      const $notification = $delete.parentNode;
  
      $delete.addEventListener('click', () => {
        $notification.parentNode.removeChild($notification);
      });
    });
  });