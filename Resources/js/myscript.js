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
			events: [
				{
					title: 'All Day Event',
					start: '2015-02-01'
				},
				{
					title: 'Long Event',
					start: '2015-02-07',
					end: '2015-02-10'
				},
				{
					id: 999,
					title: 'Repeating Event',
					start: '2015-02-09T16:01:00'
				},
				{
					id: 999,
					title: 'Repeating Event me',
					start: '2015-02-16T16:05:00',
					
				},
				{
					title: 'Conference',
					start: '2015-02-11',
					end: '2015-02-13'
				},
				{
					title: 'Meeting',
					start: '2015-02-12T10:30:00',
					end: '2015-02-12T12:30:00'
				},
				{
					title: 'Lunch',
					start: '2015-02-12T12:00:00'
				},
				{
					title: 'Meeting',
					start: '2015-02-12T14:30:00'
				},
				{
					title: 'Happy Hour',
					start: '2015-02-12T17:30:00'
				},
				{
					title: 'Dinner',
					start: '2015-02-12T20:00:00'
				},
				{
					title: 'Birthday Party',
					start: '2015-02-13T07:00:00'
				},
				{
					title: 'Click for Google',
					url: 'http://google.com/',
					start: '2015-02-28',
					end: '2015-03-12T12:30:00',
					editable:false
				}
			]
		});
		
} //
