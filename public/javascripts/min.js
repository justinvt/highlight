window.onload = function(){
var hl=document.getElementById("highlight_url")
var def="Enter URL"
hl.value=def
hl.onfocus=function(){this.value==def?this.value="":true}
hl.onblur=function(){this.value==""?this.value=def:true}
}