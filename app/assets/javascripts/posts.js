var new_post_submit = false;
$(document).on('submit','#new_post',function(e){
	e.preventDefault();
	e.stopPropagation();

	if(!new_post_submit){
		new_post_submit = true;

		var _this = $(this);
		var content  = _this.find('#post_content').val();
		var action = _this.attr('action');

		if(content != ''){
			$.post(action,{
				'authenticity_token': $('meta[name="csrf-token"]').attr('content'),
				'content':content
			},function(resp){
				$('.posts_message').html(resp.message);
				if(!resp.error){
					//clears textarea
					_this.find('#post_content').val('');

					//gets the link to get the new feed
					if(window.location.pathname.split('/')[1]=="posts"){
						var post_url = "/posts/feed/"
					}else{
						var username = window.location.pathname.split('/')[1]; 
						var post_url = "/posts/"+username+"/feed/"
					}

					//updates the feed
					$.post(post_url,{
						'authenticity_token': $('meta[name="csrf-token"]').attr('content')
					},function(resp){
						$('.post_feed_wrapper').html(resp);
						new_post_submit = false;
					});
				}else{
					new_post_submit = false;
				}

			},"json")
		}else{
			$('.posts_message').html('Content is empty');
		}
	}
})

var delete_sumbit = false;
$(document).on('click','.delete_post',function(e){
	e.preventDefault();
	e.stopPropagation();

	if(!delete_sumbit){
		delete_sumbit = true;

		var _this = $(this);
		var href = _this.attr('href');

		$.post(href,{
			'authenticity_token': $('meta[name="csrf-token"]').attr('content')
		},function(resp){
			
			if(!resp.error){
				if(window.location.pathname.split('/')[1]=="posts"){
					var post_url = "/posts/feed/"
				}else{
					var username = window.location.pathname.split('/')[1]; 
					var post_url = "/posts/"+username+"/feed/"
				}

				$.post(post_url,{
					'authenticity_token': $('meta[name="csrf-token"]').attr('content')
				},function(resp){
					$('.post_feed_wrapper').html(resp);
					delete_sumbit = false;
				});
			}else{
				alert(resp.message);
				delete_sumbit = false;
			}
		},'json')
	}
});

var comments_clicked = false;
$(document).on('click','.comments_post',function(e){
	e.preventDefault();
	e.stopPropagation();

	if(!comments_clicked){
		comments_clicked = true;

		var _this = $(this);

		if(_this.closest('.post_feed_item_wrapper').find('.comments_wrapper').html()==''){
			var href = _this.attr('href');

			$.post(href,{
				'authenticity_token': $('meta[name="csrf-token"]').attr('content')
			},function(resp){
				_this.closest('.post_feed_item_wrapper').find('.comments_wrapper').html(resp).show();
				_this.closest('.post_feed_item_wrapper').find('.create_commlmen_wrapper').show();
				comments_clicked = false;
			});
		}else{
			comments_clicked = false;
			_this.closest('.post_feed_item_wrapper').find('.comments_wrapper').html('').hide();
			_this.closest('.post_feed_item_wrapper').find('.create_commlmen_wrapper').hide();
		}
	}
});

var comment_submit = false;
$(document).on('submit','.create_commlmen_wrapper form',function(e){
	e.preventDefault();
	e.stopPropagation();

	if(!comment_submit){
		comment_submit = true;

		var _this = $(this);
		var action = _this.attr('action');
		var comment = _this.find('textarea').val();

		$.post(action,{
			'authenticity_token': $('meta[name="csrf-token"]').attr('content'),
			content:comment
		},function(resp){
			_this.find('.comment_message').html(resp.message).show();
			if(!resp.error){
				var comment_feed_url = _this.closest('.post_feed_item_wrapper').find('.comments_post').attr('href');

				$.post(comment_feed_url,{
					'authenticity_token': $('meta[name="csrf-token"]').attr('content')
				},function(feed_resp){
					_this.closest('.post_feed_item_wrapper').find('.comments_wrapper').html(feed_resp).show();
					_this.find('textarea').val('');

					comment_submit = false;
				});
			}else{
				comment_submit = false;
			}
		},"json")

	}
});

var delete_comment_click = false;
$(document).on('click','.delete_comment',function(e){
	e.preventDefault();
	e.stopPropagation();

	if(!delete_comment_click){
		delete_comment_click = true;

		var _this = $(this);
		var href = _this.attr('href');

		$.post(href,{
			'authenticity_token': $('meta[name="csrf-token"]').attr('content')
		},function(resp){
			if(!resp.error){
				var comment_feed_url = _this.closest('.post_feed_item_wrapper').find('.comments_post').attr('href');

				$.post(comment_feed_url,{
					'authenticity_token': $('meta[name="csrf-token"]').attr('content')
				},function(feed_resp){
					_this.closest('.post_feed_item_wrapper').find('.comments_wrapper').html(feed_resp).show();

					comment_submit = false;
				});
			}else{
				alert(resp.message);
				delete_comment_click = false;
			}
		},"json");

	}
});