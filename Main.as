package
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	
	import flash.events.Event;
	import flash.events.DataEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;

	public class Main extends MovieClip
	{
		private var _uploader			: FileUploader;
		private var _imageLoader		: ImageLoader;
		private var _bitmap				: Bitmap;
		
		private static const _MAX_WIDTH		: Number = 75;
		private static const _MAX_HEIGHT	: Number = 75;
		
		public function Main()
		{
			upload_btn.addEventListener(MouseEvent.CLICK, _openBrowseFile, false, 0, true);
			remove_btn.addEventListener(MouseEvent.CLICK, _removeBitmap, false, 0, true);
			
			_uploader = new FileUploader();
			_uploader.addEventListener(FileUploaderEvent.PROGRESS, _onUploadImageProgress_handler, false, 0, true);
			_uploader.addEventListener(FileUploaderEvent.FILE_SIZE_ERROR, _onFileSizeError_handler, false, 0, true);
			_uploader.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, _onUploadCompleteData_handler, false, 0, true);
			_uploader.init(FileUploader.TYPE_IMAGE, "http://localhost/php/handleUpload.php");
		};
		
		
		private function _openBrowseFile($evt:MouseEvent):void
		{
			_uploader.start();
		};
		
		private function _removeBitmap($evt:MouseEvent):void
		{
			try
			{
				thumb_mc.holder_mc.removeChild(_bitmap);
				_bitmap = null;
			}catch (e:Error) { trace("ERROR:", e); }
		};
		
		private function _onUploadImageProgress_handler($evt:FileUploaderEvent):void
		{
			trace($evt.data.pct);
		};


		private function _onFileSizeError_handler($evt:FileUploaderEvent):void
		{
			trace("File is too large to upload. Please choose a file that is smaller than", (_uploader.limit / 1000000), "MB");
		};


		private function _onUploadCompleteData_handler($evt:DataEvent):void
		{
			//trace("_onUploadCompleteData_handler", $evt)
			var xml:XML = XML($evt.data);
			var fileName:String = xml.@name.toString();
			//trace("fileName =", fileName)
			
			_imageLoader = new ImageLoader(75, 75);
			_imageLoader.addEventListener(Event.COMPLETE, _onImageLoaded, false, 0, true);
			_imageLoader.load("http://localhost/php/uploads/" + fileName);
		};
		
		
		private function _onImageLoaded($evt:Event):void
		{
			try
			{
				thumb_mc.holder_mc.removeChild(_bitmap);
				_bitmap = null;
			}catch (e:Error) { trace("ERROR:", e); }
			
			_bitmap = Bitmap(_imageLoader.content);
			_bitmap.smoothing = true;
			
			thumb_mc.holder_mc.addChild(_bitmap);
		};
		
		public function dealloc():void
		{
			upload_btn.removeEventListener(MouseEvent.CLICK, _openBrowseFile);
			remove_btn.removeEventListener(MouseEvent.CLICK, _removeBitmap);
			
			_uploader.removeEventListener(FileUploaderEvent.PROGRESS, _onUploadImageProgress_handler);
			_uploader.removeEventListener(FileUploaderEvent.FILE_SIZE_ERROR, _onFileSizeError_handler);
			_uploader.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, _onUploadCompleteData_handler);
			_uploader.dealloc();
			
			_imageLoader.removeEventListener(Event.COMPLETE, _onImageLoaded);
			_imageLoader.dealloc();
			
			_bitmap = null;
		};
	};
};


