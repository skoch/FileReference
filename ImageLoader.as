package
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	public class ImageLoader extends EventDispatcher
	{	
		private var _l			: Loader;
		private var _loaded		: Boolean = false;
		private var _maxWidth	: Number;
		private var _maxHeight	: Number;
		private var _content	: *;
		
		public function ImageLoader($width:Number, $height:Number)
		{
			super();
			
			_maxWidth = $width;
			_maxHeight = $height;
		};
		
		
		public function load($url:String):void
		{
			_loaded = false;
			_l = new Loader();
			_l.contentLoaderInfo.addEventListener(Event.COMPLETE, _imgLoaded, false, 0, true);
			_l.load(new URLRequest($url));
		};
		
		private function _imgLoaded($evt:Event):void
		{
			_l.contentLoaderInfo.removeEventListener(Event.COMPLETE, _imgLoaded);
			
			_loaded = true;
			_content = _l.content;
			
			if(_content.width > _maxWidth || _content.height > _maxHeight) _resize(_content);
			
			dispatchEvent(new Event(Event.COMPLETE));
		};
		
		
		//http://flexgraphix.com/blog/?p=51
		private function _resize($target:Bitmap):void
		{	
			trace("$target.width: " + $target.width);
			trace("$target.height: " + $target.height);
			if($target.height > $target.width)
			{
				trace("height > width", $target.rotation)
				$target.width = _maxWidth;
				$target.scaleY = $target.scaleX;
			}else if($target.width >= $target.height)
			{
				trace("width >= height", $target.rotation)
				$target.height = _maxHeight;
				$target.scaleX = $target.scaleY;
			}
		};
		
		
		public function set maxWidth(value:Number):void { _maxWidth = value; };
		public function set maxHeight(value:Number):void { _maxHeight = value; };
		
		public function get loaded():Boolean { return _loaded; };
		
		public function get content():* { return _content; };
		
		public function killLoad():void { _l.close(); };
		
		public function dealloc():void
		{
			_content = null;
			_loaded = false;
			_l = null;
		};
	};
};
