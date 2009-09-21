package
{
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.DataEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;

	public class FileUploader extends EventDispatcher
	{
		private var _uploadURL			: URLRequest;
		private var _file				: FileReference;
		private var _limit				: uint = 3000000; // set to 3MB
		private var _type				: uint;
		
		public static const TYPE_IMAGE	: uint = 0;
		public static const TYPE_TEXT	: uint = 1;
		public static const TYPE_BOTH	: uint = 2;
		
		public function init($type:uint, $url:String):void
		{
			_uploadURL = new URLRequest();
			_type = $type;
			_uploadURL.url = $url;
		};
		
		public function start():void
		{
			_file = new FileReference();
			_configureListeners();
			_file.browse(_getTypes());
		};

		private function _configureListeners():void
		{
			_file.addEventListener(Event.CANCEL, _cancel_handler);
			_file.addEventListener(ProgressEvent.PROGRESS, _progress_handler);
			_file.addEventListener(Event.COMPLETE, _complete_handler);
			_file.addEventListener(Event.SELECT, _select_handler);
			_file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, _uploadCompleteData_handler);
			//_file.addEventListener(Event.OPEN, _open_handler);
			//_file.addEventListener(HTTPStatusEvent.HTTP_STATUS, _httpStatus_handler);
			//_file.addEventListener(IOErrorEvent.IO_ERROR, _ioError_handler);
			//_file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityError_handler);
		};
		
		
		private function _select_handler($evt:Event):void
		{
			var file:FileReference = FileReference($evt.target);
			if(file.size >= _limit)
			{
				dispatchEvent(new FileUploaderEvent(FileUploaderEvent.FILE_SIZE_ERROR));
				_removeListeners();
				return;
			}
			//trace("select_handler: name=" + file.name + ", file.size = " + file.size + " URL=" + _uploadURL.url);
			file.upload(_uploadURL);
		};
		
		
		private function _progress_handler($evt:ProgressEvent):void
		{
			var file:FileReference = FileReference($evt.target);
			//trace("progress_handler name=" + file.name + " bytesLoaded=" + $evt.bytesLoaded + " bytesTotal=" + $evt.bytesTotal);
			var pct:Number = Math.round(($evt.bytesLoaded / $evt.bytesTotal) * 100);
			dispatchEvent(new FileUploaderEvent(FileUploaderEvent.PROGRESS, {pct:pct}));
		};


		
		private function _getTypes():Array
		{
			var types:Array
			switch(_type)
			{
				case TYPE_IMAGE :
					types = new Array(_getImageTypeFilter());
				break;
				case TYPE_TEXT :
					types = new Array(_getTextTypeFilter());
				break;
				case TYPE_BOTH :
					types = new Array(_getImageTypeFilter(), _getTextTypeFilter());
				break;
			}
			return types;
		};
		
		
		private function _getImageTypeFilter():FileFilter
		{
			return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
		};
		
		
		private function _getTextTypeFilter():FileFilter
		{
			return new FileFilter("Text Files (*.txt, *.rtf)", "*.txt;*.rtf");
		};
		
		
		private function _cancel_handler($evt:Event):void
		{
			_removeListeners();
		};


		private function _complete_handler($evt:Event):void
		{
//			trace("complete_handler: " + $evt.target);
//			var fr:FileReference = FileReference($evt.target);
//			trace("fr.data", fr.data);
//			trace("fr.name", fr.name);
//			trace(fr.data.readUTFBytes(fr.data.length));
		};


		private function _uploadCompleteData_handler($evt:DataEvent):void
		{
			_removeListeners();
			//trace("uploadCompleteData: " + $evt.target);
			//var fr:FileReference = FileReference($evt.target);
			//trace("fr.data", fr.data)
			dispatchEvent($evt);
		};


		private function _removeListeners():void
		{
			_file.removeEventListener(Event.CANCEL, _cancel_handler);
			_file.removeEventListener(ProgressEvent.PROGRESS, _progress_handler);
			_file.removeEventListener(Event.COMPLETE, _complete_handler);
			_file.removeEventListener(Event.SELECT, _select_handler);
			_file.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, _uploadCompleteData_handler);
			_file = null;
		};
		
		public function get limit():uint { return _limit; };
		public function set limit(value:uint):void
		{
			// limit can't be higher than 10MB
			if(value > 10) _limit = 10000000;
			else _limit = value * 1000000;
		};
		
		
		public function dealloc():void
		{
			_uploadURL = null;
			_file = null;
			_limit = Number.NaN
			_type = Number.NaN;
		};
		
		
		//private function _open_handler($evt:Event):void
		//{
		//	trace("open_handler: " + $evt);
		//};
		//private function _httpStatus_handler($evt:Event):void
		//{
		//	trace("_httpStatus_handler: " + $evt);
		//};
		//private function _ioError_handler($evt:Event):void
		//{
		//	trace("_ioError_handler: " + $evt);
		//};
		//private function _securityError_handler($evt:Event):void
		//{
		//	trace("_securityError_handler: " + $evt);
		//};
	};
};