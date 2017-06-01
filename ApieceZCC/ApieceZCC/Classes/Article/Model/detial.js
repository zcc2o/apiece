window.onload = function(){
    
    console.log("能不能通啊？？？！！！");
    
    var img = document.getElementByClassName('image')[0];
    
    img.onclick=function(){
        
        alert("是不是不通");
    }
    
}


function imgClick()
{
    var imgs=document.getElementByClassName("image");
    
    for(var i=0;i<imgs.length;i++){
        
        var src = imgs.[i].src;
        
        imgs[i].setAttribute("onClick","change_pic(src)");
        
        alert('zcc');
        
    }
    
    document.location = imageurls;
}



function imageClicked(){
    jakilllog("hello world");
}
