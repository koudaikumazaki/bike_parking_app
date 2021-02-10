'use strict'; 
{
  document.addEventListener("DOMContentLoaded", () => {
    
    document.addEventListener("turbolinks:load", () => {
      const open = document.getElementsByClassName('open')[0];
      const close = document.getElementsByClassName('close')[0];
      const sp_navi = document.getElementsByClassName('sp_navi')[0];
      open.addEventListener('click', () => {
        sp_navi.classList.add('show');
        open.classList.add('hide');
      });
    
      close.addEventListener('click', () => {
        sp_navi.classList.remove('show');
        open.classList.remove('hide');
      });
    });
  });
}
