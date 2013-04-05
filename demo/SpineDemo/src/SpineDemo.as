package
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.core.IAnimatedObject;
	import com.pblabs.engine.resource.ImageResource;
	import com.pblabs.engine.resource.JSONResource;
	import com.pblabs.engine.resource.XMLResource;
	import com.pblabs.starling2D.SceneViewG2D;
	
	import flash.display.Sprite;
	
	import spine.Animation;
	import spine.Skeleton;
	import spine.SkeletonData;
	import spine.SkeletonJson;
	
	import starling.display.QuadBatch;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	[SWF(width="720", height="400", frameRate="60")]
	public class SpineDemo extends Sprite implements IAnimatedObject
	{
		public var spineBoyTexturePackerJson : JSONResource;
		public var spineBoyStarlingAtlasXML : XMLResource;
		public var spineBoySkeletonJson : JSONResource;
		public var spineBoyWalkAnimationJson : JSONResource;
		public var spineBoySpriteSheetImage : ImageResource;
		
		public var skeleton : Skeleton;
		public var skeletonRenderer : QuadBatch;
		public var skeletonDebugRenderer : Sprite;
		public var walkAnimation : Animation; 
		
		public var gpuView : SceneViewG2D
		
		private var _time : Number = 0;
		private var _direction : int = 0
		
		
		public function SpineDemo()
		{
			PBE.startup(this);
			PBE.processManager.addAnimatedObject( this );
			
			//Instantiate Embedded Resources
			new AssetsBundle();
			
			//Store resource handles
			spineBoyTexturePackerJson = PBE.resourceManager.load("assets/spineboy/spineboy-array.json", JSONResource) as JSONResource;
			spineBoySkeletonJson = PBE.resourceManager.load("assets/spineboy/spineboy-skeleton.json", JSONResource) as JSONResource;
			spineBoyWalkAnimationJson = PBE.resourceManager.load("assets/spineboy/spineboy-walk.json", JSONResource) as JSONResource;
			spineBoyStarlingAtlasXML = PBE.resourceManager.load("assets/spineboy/spineboy_starling.xml", XMLResource) as XMLResource;
			spineBoySpriteSheetImage = PBE.resourceManager.load("assets/spineboy/spineboy_starling.png", ImageResource) as ImageResource;
			
			gpuView = new SceneViewG2D();
			//Listen for context creation
			gpuView.starlingInstance.addEventListener("rootCreated", onContextInitialized);
			gpuView.starlingInstance.showStats = true;
			this.addChild( gpuView );
		}
		
		public function onContextInitialized(event : Event):void
		{
			//Non GPU Debug layer to draw bones
			skeletonDebugRenderer = new Sprite();
			skeletonDebugRenderer.x = 0;
			skeletonDebugRenderer.y = 400;
			this.addChild(skeletonDebugRenderer);
			
			skeletonRenderer = new QuadBatch();
			skeletonRenderer.x = 0;
			skeletonRenderer.y = 400;
			gpuView.addDisplayObject( skeletonRenderer );
			
			var spineSkeletonTextureAtlas : TextureAtlas = new TextureAtlas( Texture.fromBitmapData( spineBoySpriteSheetImage.bitmapData ), spineBoyStarlingAtlasXML.XMLData );
			
			//Parse Spine Skeleton Data via the static factory using StarlingAttachmentLoader
			var skeletonJson : SkeletonJson = SkeletonJson.createSkeletonFromAtlas( spineSkeletonTextureAtlas );
			
			var skeletonData : SkeletonData = skeletonJson.readSkeletonData( spineBoySkeletonJson.jsonString , "spineboy-skeleton" );
			walkAnimation = skeletonJson.readAnimation( spineBoyWalkAnimationJson.jsonString , skeletonData, "spineboy-walk" );
			
			skeleton = new Skeleton(skeletonData);
			//Needed for bones and attachments to show up in place
			skeleton.setSlotsToBindPose();
			skeleton.updateWorldTransform();
			
			skeleton.draw( skeletonRenderer );
		}
		
		public function onFrame(deltaTime:Number):void
		{
			if(!skeletonRenderer)
				return;
			
			skeletonRenderer.reset();
			
			var deltaSecs : Number = PBE.processManager.virtualTime / 1000;
			
			walkAnimation.apply(skeleton, deltaSecs , true);
			
			if((skeletonRenderer.x - 200) > this.stage.stageWidth){
				_direction = 1;
				skeleton.flipX = true;
			}else if((skeletonRenderer.x + 200) < 0){
				skeleton.flipX = false;
				_direction = 0;
			}
			
			var speed : Number = 3 * PBE.processManager.timeScale;
			
			skeletonRenderer.x += _direction ? -speed : speed;
			skeletonDebugRenderer.x += _direction ? -speed : speed;
			
			//Update bones positions
			skeleton.updateWorldTransform();
			
			//Draw or Paint to renderer
			skeleton.draw( skeletonRenderer );
			skeleton.drawDebug(skeletonDebugRenderer);
		}
	}
}