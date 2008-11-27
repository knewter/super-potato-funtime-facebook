function remove_all_widgets()
{
  jQuery('div.widget_instance').remove();
}

function update_z_index_text( z_index )
{
  jQuery('#widget-controls').find('label').html('Z-Index: <strong>' + z_index + '</strong>');
}

function increase_z_index()
{
  var widget = jQuery('#widget-controls');
  var target = jQuery('#' + widget.attr("target") );
  var z_index = 0;
  if( target )
  {
    z_index = get_z_index_of( target );
    target.css('z-index', get_z_index_of( target)  + 1);
    update_z_index_text( z_index + 1 );
  }
}

function decrease_z_index()
{
  var widget = jQuery('#widget-controls');
  var target = jQuery('#' + widget.attr("target") );
  var z_index = 0;
  if( target )
  {
    z_index = get_z_index_of( target );
    target.css('z-index', get_z_index_of( target ) - 1);
    update_z_index_text( z_index -1 );
  }
}

function get_z_index_of( target )
{
  var z_index = parseInt(target.css('z-index'), 10);
  if( isNaN( z_index ) )
  {
    z_index = 1;
  }
  if( z_index <= 0 )
  {
    z_index = 1;
  }
  return z_index;
}

function build_widget_positions()
{
  var widgets   = jQuery('div.widget_instance');
  var url       = '/potato_man/' + jQuery('#potato_man_id').val();
  var positions = [];
  var potato_man = jQuery('.potato_man');
  var potato_man_offset = potato_man.offset();
  jQuery.each( widgets, function()
  {
    var widget      = jQuery(this);
    var offset_top  = widget.offset().top - potato_man_offset.top;
    var offset_left = widget.offset().left - potato_man_offset.left;
    var z_index     = get_z_index_of( widget );
    positions.push([ widget.find('img').attr("id"), offset_left, offset_top, z_index ]);
  });

  var form = jQuery('#update-potato-man-form').find('form:first');
  jQuery("#widget-positions-hidden").remove();
  jQuery.each( positions, function()
  {
    var widget_id_and_position_to_csv = [this[0],this[1],this[2],this[3]].join(',');
    form.append( jQuery("<div id=\"widget-positions-hidden\"><input type=\"hidden\" name=\"widget_instances[]\" value=\"" + widget_id_and_position_to_csv  + "\"/></div>") );
  });

  return true;
}

function update_position( widget )
{
  // A widget was repositioned. Save the state.
  var img = widget.find('img');
  var url = '/potato_men/' + jQuery('#potato_man_id').val() +'/widget_instances/' + img.attr('id') + '/reposition';
  var offset_top = widget.offset().top - jQuery('.potato_man').offset().top;
  var offset_left = widget.offset().left - jQuery('.potato_man').offset().left;
  jQuery.ajax({
    type: "GET",
    gloabl: false,
    url: url,
    data: 'z_index=' + widget.css('z-index') + '&top='+ offset_top + '&left=' + offset_left
  });
  
}

function bind_widget_controls( widget )
{
  if( widget.hasClass('selected-widget') == false)
  {
    jQuery('.selected-widget').removeClass('selected-widget'); // Only one widget editable at a time
    widget.addClass('selected-widget');
    jQuery('#widget-controls').attr("target", widget.attr("id"));
    jQuery('#remove-selected-widget').unbind('click');
    jQuery('#remove-selected-widget').click( function()
    {
       widget.remove();
       jQuery.ajax({
         type: "GET",
         url: "/potato_men/" + jQuery('#potato_man_id').val() + "/widget_instances/" + widget.find('img').attr("id") + "/remove"
       });
    });
  }
}

function show_available_widgets( url )
{
  jQuery.ajax(
  {
    url: url,
    type: 'GET',
    global: false,
    complete: function(transport)
    {
      var widget_selection = jQuery('#widget-selection');
      widget_selection.html( transport.responseText );
      if( jQuery('div.ui-dialog').size() == 0 )
      {
        widget_selection.dialog({ 
              modal: true,
              width: "500px",
              dialogClass: 'widget-selection', 
              height: "auto",
              overlay: { 
                opacity: 0.5, 
                background: "black" 
              } 
        });
      } else {
        widget_selection.dialog("open");
      }
      // When a widget is selected, add it to the DOM and bind a click to the image to show
      // the movement controls
      jQuery('a.widget').click(function() 
      {
        // Go ahead and bind the widget to the current potato man
        var anchor = this;
        var img = jQuery(this).find('img');
        var full_image = img.attr('src').replace(/\/thumb\//, '/original/');
        var new_widget = jQuery("<div class='widget_instance'></div>");
        var new_img = jQuery("<img class='widget' src='"+ full_image +"'/>");
        new_widget.append( new_img );
        var top_offset = -jQuery('div.potato_man').height() + new_widget.offset().top + 200;
        new_widget.css({ width: new_img.width(), "z-index": '1', position: 'relative', top: top_offset , display: "none" });
        jQuery('div.widget-instances').append( new_widget );
        new_widget.css("margin-right", "0px"); // webkit wants to make the margin-right 1010px on append. Strange ..
        
        new_widget.show("drop", {direction: "up"})

        jQuery.ajax({
          type: "GET",
          url: anchor.href,
          global: false,
          complete: function(transport)
          {
            var response = eval('[' +  transport.responseText + ']');
            new_widget.attr("id",  "widget_instance_" + response[0].widget_instance.id);
            new_widget.find('img').attr("id", response[0].widget_instance.id);
          }
        });
        new_widget.draggable(
            { 
              containment: jQuery('div.potato_man')
            });
        
        new_widget.click(function() 
        {
          bind_widget_controls( jQuery(this) );
        });
        
        widget_selection.dialog("close");
        return false;
      });
    }
  });
}

jQuery(document).ready(function()
{
  jQuery('.new_widget_instance').click( function() 
  {
    show_available_widgets( this.href );
    return false;
  });
  var widget_instances = jQuery('div.widget_instance'); 
  widget_instances.draggable(
        { 
          containment: jQuery('div.potato_man'),
        });
  widget_instances.click( function(){
    update_z_index_text( get_z_index_of( jQuery(this) ) );
    bind_widget_controls( jQuery(this) );
  });

  jQuery('#increase_z_index').click(function()
  {
    increase_z_index();
  });

  jQuery('#decrease_z_index').click(function()
  {
    decrease_z_index();
  });
  
  jQuery('#remove-selected-widget').click(function() { return false; }); 

});
