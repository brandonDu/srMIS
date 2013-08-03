$(document).ready(function() {
	// Stuff to do as soon as the DOM is ready;
	loadList();
	$('#registerUser').validate({
	    rules: {
	      user_no: {
	        rangelength:[4,10],
	        required: true
	      },
	      user_name: {
	        required: true
	      },
	      user_idn: {
	      	required:true
	      },
	      user_pwd: {
	        rangelength: [6,10],
	        required: true
	      },
	      confirm_pwd: {
	        rangelength: [6,10],
	        required: true,
	        equalTo: "#user_pwd"
	      }
	    },
	     messages: {
			   user_no:{
			   	required:"请输入用户名",
			   	rangelength: $.validator.format(" ")	
			   },
			   user_name: {
			    required: "请输入您的真实姓名"
			   },
			   user_idn: {
			    required: "请输入证件号"			    
			   },
			   user_pwd: {
			    required: "请输入密码",
			    rangelength: $.validator.format(" 密码长度应在{0} 到{1}位")
			   },
			   confirm_pwd: {
			    required: "请输入确认密码",
			    rangelength: $.validator.format(" 密码长度应在{0} 到{1}位"),
			    equalTo: "两次输入密码不一致"
			   }
			  },
			highlight: function(element) {
				$(element).closest('.control-group').removeClass('success').addClass('error');
			},
			success: function(element) {
				element				
				.closest('.control-group').removeClass('error').addClass('success');
			}
	  });
	$('#register').bind('click',function(){
		registerUser();
	});


});
var loadList=function(){
	$.ajax({
        type: 'GET',
  		url: "/s/user/",
        data: '',
        dataType: 'json' 
	})
    .done(function(data) {
        render_list(data);
    });
};
var render_list=function(list){
	var tbody =  $("#userTable tbody").empty();
    for (i in list) {
        var user = list[i];

        var $row = $('<tr>');
        $('<td>').text(parseInt(i) + 1).appendTo($row);
        $('<td>').text(user['no']).appendTo($row);
        $('<td>').text(user['name']).appendTo($row);        
        $('<td>').text(user['enrolled']).appendTo($row);

        var btn_edit = $('<button class="btn btn-primary btn-block disabled" >')
            .text('修改').attr('name',user['sn'])
            .on( "click", (function(user) {
                return function( event ) {
                    var sn = user['sn'];                   
                    edit_user(sn);
                }
            })(user));

        var btn_del = $('<button class="btn btn-primary btn-block">')
            .text('删除').attr('name',user['sn'])
            .on( "click", (function(item) { 
                return function( event ) {
                    delete_user(item['sn']);
                }
            })(user));

        $('<td>').append(btn_edit).append(btn_del).appendTo($row);

        $row.appendTo(tbody);
    }
}

var registerUser=function(){
	var item={};
	item['no'] =$('#user_no').val();
	item['name']=$('#user_name').val();
	item['idn'] =$('#user_idn').val();
	item['pwd'] =$('#user_pwd').val();	
	var d = new Date();
	var date=d.getFullYear()+'-'+(d.getMonth()+1)+'-'+d.getDate();
	item['enrolled']=date;
	$.ajax({ 
            type: 'POST', 
            url: '/s/user/',
            data: JSON.stringify(item),
            dataType: 'json' 
        })
        .done(function(){
            loadList();
            
        });
        return false;
}
var edit_user=function(sn){
	function put_student(vsn) {
        var item = {};
        
        item['sn'] = vsn;
        item['no'] =$('#user_no').val();
		item['name']=$('#user_name').val();
		item['idn'] =$('#user_idn').val();
		item['pwd'] =$('#user_pwd').val();
		var d = new Date();
		var date=d.getFullYear()+'-'+(d.getMonth()+1)+'-'+d.getDate();
		item['enrolled']=date;	
        var jsondata = JSON.stringify(item);
        $.ajax({ 
            type: 'PUT', 
            url: '/s/user/' + vsn,
            data: jsondata,
            dataType: 'json' 
        })
        .done(function(){
            load_list();
            $('#dlg-student-form').hide()
        });
        return false; // 在AJAX下，不需要浏览器完成后续的工作。
    }

    $.ajax({ 
        type: 'GET', 
        url: '/s/user/' + sn,
        dataType: 'json' 
    })
    .then(function(item) {      
        $('#user_no').val(item['no']);
        $('#user_name').val(item['name']);
        $('#user_idn').val(item['idn']);
        $('#user_pwd').val(item['pwd']);       
        $('#registerUser').off('submit').on('submit', put_student(sn));        
    }); 
}
var delete_user=function(sn){	
	$.ajax({
        type: 'DELETE',
        url: '/s/user/' + sn,
        dataType: 'html'
    })
    .done(function() {
        loadList();
    });
}