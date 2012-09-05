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
          html: true
        });
        
        // Allow collapsible divs
        $(".collapse").collapse();
        
        // jQuery timeago plugin
        $.timeago.settings.allowFuture = true;
        $("time.timeago").timeago();
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
        }
    },
    
    admin: {
      
        init: function() {
            $('#confirm_delete').modal({
                backdrop: true,
                keyboard: true,
                show:     false
            });
            $('#confirm_delete_cancel').click(function() {
                $('#confirm_delete').modal('hide'); 
             });
            
            $('input[name="siteservice_mode"]').change(sb.admin.siteservice.modeChanged).trigger('change');
            
            // Ajax pushState support for any clickable link
            $('a[data-uri]').click(sb.admin.saveState);
            
            // Trigger an initial state push for the default tab
            if ($('li.active a[data-uri]').size()) {
                sb.admin.setInitialState($('li.active a[data-uri]').attr('href').replace(/#tab_/, ''));
            }
            
            $(window).bind('popstate', sb.admin.stateChanged);
        },
        
        saveState: function(e) {
            state = {
                tab: $(this).attr('href').replace(/#tab_/, '')
            };
            window.history.pushState(state, $(this).text(), $(this).data('uri'));
            
            e.preventDefault();
        },
        
        setInitialState: function(tab) {
            state = {
                tab: tab
            };
            window.history.replaceState(state, "Admin", base_uri + 'admin/tab/' + tab + '/');
        },
        
        stateChanged: function(e) {
            state = null
            if (e.state) {
                state = e.state;
            } else if (e.originalEvent.state) {
                state = e.originalEvent.state;
            }
            
            if (state && state.tab) {
                $('#admin_tabs li a[href="#tab_' + state.tab + '"]').tab('show');
            }
            
            e.preventDefault();
        },
        
        deleteItem: function(url, csrftoken) {
            $('#confirm_delete_do').click(function() {
                sb.request.post(url, {
                    csrftoken: csrftoken
                });
            });
            
            $('#confirm_delete').modal('show');
        },
        
        siteservice: {
            modeChanged: function(e) {
                $('.siteservice_contents').hide();
                $('#siteservice_' + $('input[name="siteservice_mode"]:checked').val()).show();
            }
        },
        
        user:  {
            
            init: function() {
                $('#admin_user_passwd_new,#admin_user_passwd_confirm').bind('keyup', sb.admin.user.checkPassword);
                
            },
            
            checkPassword: function() {
                password = $('#admin_user_passwd_new');
                confirm = $('#admin_user_passwd_confirm');
                
                confirm_container = confirm.parent().parent();
                
                if (password.val() == confirm.val()) {
                    confirm_container.removeClass('error').addClass('success');
                    $('#admin_user_passwd_confirmpassword_help').hide();
                } else {
                    confirm_container.addClass('error').removeClass('success');
                    $('#admin_user_passwd_confirmpassword_help').show();
                }
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
