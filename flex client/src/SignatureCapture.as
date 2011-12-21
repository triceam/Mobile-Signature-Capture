package
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.graphics.ImageSnapshot;
	import mx.managers.IFocusManagerComponent;
	
	import spark.primitives.Graphic;
	
	public class SignatureCapture extends UIComponent
	{
		private var captureMask : Sprite;
		private var drawSurface : UIComponent;
		private var lastMousePosition : Point;
		
		private var backgroundColor : int = 0xEEEEEE;
		private var borderColor : int = 0x888888;
		private var borderSize : int = 2;
		private var cornerRadius :int = 25;
		private var strokeColor : int = 0;
		private var strokeSize : int = 2;
		
		public function SignatureCapture()
		{
			lastMousePosition = new Point();
			super();
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			captureMask = new Sprite();
			drawSurface = new UIComponent();
			this.mask = captureMask;
			addChild( drawSurface );
			addChild( captureMask );
			
			this.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		}
		
		protected function onMouseDown( event : MouseEvent ) : void
		{
			lastMousePosition = globalToLocal( new Point( stage.mouseX, stage.mouseY ) );
			stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
		}
		
		protected function onMouseMove( event : MouseEvent ) : void
		{
			updateSegment();
		}
		
		protected function onMouseUp( event : MouseEvent ) : void
		{
			updateSegment();
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
		}
		
		protected function updateSegment() : void
		{
			var nextMousePosition : Point = globalToLocal( new Point( stage.mouseX, stage.mouseY ) );
			renderSegment( lastMousePosition, nextMousePosition );
			lastMousePosition = nextMousePosition;
		}
		
		
		public function clear() : void
		{
			drawSurface.graphics.clear();
		}
		
		override public function toString() : String
		{
			var snapshot : ImageSnapshot = ImageSnapshot.captureImage( drawSurface );
			return ImageSnapshot.encodeImageAsBase64( snapshot );
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w,h);
			
			drawSurface.width = w;
			drawSurface.height = h;
			
			var g : Graphics = this.graphics;
			
			//draw rectangle for mouse hit area
			g.clear();
			g.lineStyle( borderSize, borderColor, 1, true );
			g.beginFill( backgroundColor, 1 );
			g.drawRoundRect( 0,0,w,h, cornerRadius, cornerRadius );
		
			
			//fill mask
			g = captureMask.graphics;
			g.clear();
			g.beginFill( 0, 1 );
			g.drawRoundRect( 0,0,w,h, cornerRadius, cornerRadius );
		}
		
		protected function renderSegment( from : Point, to : Point ) : void
		{
			var g : Graphics = drawSurface.graphics;
			g.lineStyle( strokeSize, strokeColor, 1 );
			g.moveTo( from.x, from.y );
			g.lineTo( to.x, to.y );
		}
	}
}