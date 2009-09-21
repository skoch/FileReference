package
{
	import flash.events.Event;

	public class FileUploaderEvent extends Event
	{
		public static const FILE_SIZE_ERROR:String = "onFileSizeError";
		public static const PROGRESS:String = "onProgress";
		
		private var _info		: Object;
		public function get info():Object { return _info; };
		public function get data():Object { return _info; };
		
		public function FileUploaderEvent( type:String, info:Object = null, bubbles:Boolean=true, cancelable:Boolean=false )
		{
			super(type, bubbles, cancelable);
			_info = info;
		};
	
		override public function clone():Event
		{
			return new FileUploaderEvent(type, info, bubbles, cancelable);
		};
	};
};
