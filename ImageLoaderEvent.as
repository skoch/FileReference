package
{
	import flash.events.Event;

	public class ImageLoaderEvent extends Event
	{
		public static const COMPLETE:String = "onComplete";
		public static const PROGRESS:String = "onProgress";
		
		private var _info		: Object;
		public function get info():Object { return _info; };
		public function get data():Object { return _info; };
		
		public function ImageLoaderEvent( type:String, info:Object = null, bubbles:Boolean=true, cancelable:Boolean=false )
		{
			super(type, bubbles, cancelable);
			_info = info;
		};
	
		override public function clone():Event
		{
			return new ImageLoaderEvent(type, info, bubbles, cancelable);
		};
	};
};
