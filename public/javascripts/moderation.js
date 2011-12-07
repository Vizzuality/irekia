		
		var colors = {ok:'#E2E6BD',ko:'#FF855C', 'null':'#F6F6F7'},
		loading = false,
		mobile = false,
		older_first = false,
		page = 2;

		$(document).ready(function(){
		  // Mobile
		  if( navigator.userAgent.match(/Android/i) || navigator.userAgent.match(/webOS/i) || navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPod/i)){
		    mobile = true;
		    $('ul.info li.last p').html('tiempo<br/>medio');
		  }
  
		  checkModeration();


		  $('div.order span.buttons a').click(function(ev){
		    var order = $(this).closest('div.order');
		    var move = order.find('span.move');

		    var p_w = order.width();
		    var pad = parseInt($(this).css('paddingLeft').replace('px',''));
		    var w = $(this).width() + (pad*2) - 2; //18 - 2(borders)
		    var p = $(this).position().left + 3;

		    move.animate({
		      left:p + 'px',
		      width: w  + 'px'
		    },300);

		    order.find('span.buttons a').css({color:'#7D8700'});
		    $(this).css({color:'#333333'});
		  });


		  $('li div.moderation span.buttons button').click(function(ev){
		  	ev.preventDefault();
		  	ev.stopPropagation();

		    var moderation = $(this).closest('div.moderation');
		    var li = $(this).closest('li');
		    var move = moderation.find('span.move');

		    var p_w = moderation.width(),
		    		w = $(this).width() + 16, //18 - 2(borders)
		    		p = $(this).position().left + 3,
		    		that = this;

		    var t = $(this).attr('class');

		    move.animate({
		      left:p + 'px',
		      width: w  + 'px'
		    },300);

		    moderation.animate({
		      backgroundColor:colors[t]
		    },300);

		    if (t == 'ko') {
		      moderation.find('span.buttons button').css({color:'#FCC3AE'});
		    } else if (t == 'ok') {
		      moderation.find('span.buttons button').css({color:'#B5B996'});
		    } else {
		      moderation.find('span.buttons button').css({color:'#7D8700'});
		    }
		    $(this).css({color:'#333333'});

		    // Remove after 5 secs if it is not null
		    if (t == 'null') {
		      li.stop(true);
		    } else {
		      li.stop(true).delay(5000).animate({
		        opacity:0
		      },500,function(){
		        $(this).animate({height:0,paddingTop:0,paddingBottom:0},500,function(){
		          $(this).remove();
							if ($('.article.activity div.content ul li').size()==0) {
					      $('span.no_content').css({'display':'inline-block'});
					      $('.article.activity').hide();
					    }
		        });
		        $(that).closest('form').submit();
		      });
		    }
		  });
  
		  $('form').live('ajax:success',function(ev,data,obj){
		    $('.article.total_info ul.info').remove();
		    $('.article.total_info div.content').prepend(data);
		  });

		  $('span.buttons a.recents, span.buttons a.olds').click(function(ev){
		    ev.preventDefault();
		    $('.article.activity').hide();
		    $('.article.activity ul li').remove();
		    page = 1;
		    older_first = $(this).hasClass('olds') === 'olds';
		    loadMore(page,older_first);
		  });

		  $(window).scroll(function(ev){
		    if (!loading && (($(document).scrollTop() + $(window).height() + (mobile?60:0)) >= $(document).height())) {
		      loadMore(page,older_first);
		    }
		  });
		});

		function loadMore() {
		  loading = true;
  
		  $('span.loader').css({'display':'inline-block'});
		  $('span.no_content').css({'display':'none'});
  
		  $.get('/admin/moderation?page='+page+'&oldest_first='+older_first,function(data){
		    var info = $(data);
		    page++;
    
		    // Ul info
		    $('.article.activity ul').append(info);
		    $('.article.activity ul.info').remove();
    
		    $('.article.total_info ul.info').remove();
		    $('.article.total_info .inner div.content').prepend(info[0]);
				if (mobile) {
					$('ul.info li.last p').html('tiempo<br/>medio');
				}
    
		    loading = false;
    
		    if (info.length<2) {
		      $('span.no_content').css({'display':'inline-block'});
		    } else {
		      $('.article.activity').show();
		    }
    
		    $('span.loader').hide();
    
		    checkModeration();
		  });
		}


		function checkModeration() {
		  $('li div.moderation').each(function(i,ele){
		    var w = 0;
		    $(this).find('span.buttons button').each(function(i,b){
		      w += $(b).width() + 18;
		    });
    
		    $(ele).width(w + 6);
		    var move = $(ele).find('span.move');
		    var w_n = $(ele).find('button.null').width() + 16;
		    var p = $(ele).find('button.null').position().left + 3;
		    move.css({left:p+'px',width:w_n+'px'});
		  });
		}