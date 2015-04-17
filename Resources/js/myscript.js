function goCalendar(melang, ftime,fday) {

    if(!melang)
    {
        //console.log('<');
        melang='ru';
    }

    if(!ftime)
    {
        ftime='h(:mm)t';
    }
    ftime='h(:mm)t - h(:mm)t';
    if(!fday)
    {
        fday=0;
    }

    $('#calendar').fullCalendar({
        header: {
            left: 'prev,next today',
    center: 'title'
        },
    lang: melang,
    firstDay:fday,
    defaultDate: '2015-02-12',
    editable: true,
    timeFormat: ftime,
    eventLimit: true, // allow "more" link when too many events
    events: function(start, end, timezone, callback) {

        
        var calendar = $('#calendar').fullCalendar('getCalendar');
        console.log(calendar.moment(1427673600*1000).unix());

        var moment = calendar.getDate();

        $.ajax({
            url: 'api/getorders/',
            data: {
                // our hypothetical feed requires UNIX timestamps
            start:moment.unix() ,
            end: end.unix()
            },
            success: function(doc) {
            console.log(doc);
                        
                var events = [];
                
                var result = JSON.parse(doc);

                for (var i = 0; i < result.length; i++) {
                //console.log(calendar.moment(result[i].time_start *1000 ).format());
                    events.push({
                        title:result[i].info,
                        editable:false,
                        start:calendar.moment(result[i].time_start *1000 ).format(),
                        end:calendar.moment(result[i].time_end *1000 ).format()
                    });
                }
                
                
                console.log(events);
                //callback(result);
                        callback(events);
                //console.log(events);
            }
        });

    }            
    });

} //

function getCookie(name) {
  var matches = document.cookie.match(new RegExp(
    "(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"
  ));
  return matches ? decodeURIComponent(matches[1]) : undefined;
}




