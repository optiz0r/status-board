/**
 * StatusBoard main script file
 *
 * 
 */

 
var sb = {
     
    init: function() {
        // Properly format any alert boxes
        $('.alert-data').alert();
        
        // Properly format any tab widgets
        $('.tabs').tabs();
        
        // Display popovers on all configured items
        $("a[rel=popover]").popover({
          offset: 10,
          html: true,
        });
    },
    
    home: {
        
        init: function() {
            sb.home.maintenanceListTicker();
        },
        
        maintenanceListTicker: function() {
            if ($('#maintenance-list li').size() > 1) {
                $('#maintenance-list li:first').animate({marginTop: '-20px'}, 800, function() {
                    $(this).detach().appendTo('#maintenance-list').removeAttr('style');
                });
                
                setTimeout(sb.home.maintenanceListTicker, 5000);
            }
        },
    },
    
    admin: {
      
        init: function() {
            $('#confirm_delete').modal({
                backdrop: true,
                keyboard: true,
                show:     false,
            });
            $('#confirm_delete_cancel').click(function() {
                $('#confirm_delete').modal('hide'); 
             });
            
            $('input[name="siteservice_mode"]').change(sb.admin.siteservice.modeChanged).trigger('change');
        },
        
        deleteItem: function(url, csrftoken) {
            $('#confirm_delete_do').click(function() {
                sb.request.post(url, {
                    csrftoken: csrftoken,
                });
            });
            
            $('#confirm_delete').modal('show');
        },
        
        siteservice: {
            modeChanged: function(e) {
                $('.siteservice_contents').hide();
                $('#siteservice_' + $('input[name="siteservice_mode"]:checked').val()).show();
            }
        }
        
    },
     
    usercp: {
 
        init: function() {
            $('#usercp_newpassword,#usercp_confirmpassword').bind('keyup', sb.usercp.checkPassword);
             
        },
         
        checkPassword: function() {
            password = $('#usercp_newpassword');
            confirm = $('#usercp_confirmpassword');
             
            confirm_container = confirm.parent().parent();
             
            if (password.val() == confirm.val()) {
                confirm_container.removeClass('error').addClass('success');
                $('#usercp_confirmpassword_help').hide();
            } else {
                confirm_container.addClass('error').removeClass('success');
                $('#usercp_confirmpassword_help').show();
            }
        }
         
    },
    
    request: {
        
        post: function(url, data) {
            var form = $('<form />').attr('method', 'post').attr('action', url);
            for (var key in data) {
                form.append($('<input type="hidden">').attr('name', key).val(data[key]));
            }
            
            form.submit();
        }
        
    },
    
};
 
$('document').ready(sb.init);
