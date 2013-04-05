package
{
	import com.pblabs.engine.resource.ResourceBundle;
	
	public class AssetsBundle extends ResourceBundle
	{
		[Embed(source="assets/spineboy/spineboy-array.json", mimeType = 'application/octet-stream')]
		public var spineboyTexturePackerDividerData:Class;
		
		[Embed(source="assets/spineboy/spineboy-skeleton.json", mimeType = 'application/octet-stream')]
		public var spineboySkeletonData:Class;

		[Embed(source="assets/spineboy/spineboy-walk.json", mimeType = 'application/octet-stream')]
		public var spineboyWalkAnimationData:Class;

		[Embed(source="assets/spineboy/spineboy_starling.xml", mimeType = 'application/octet-stream')]
		public var spineboyStarlingTexturePackerAtlasData:Class;
		
		[Embed(source="assets/spineboy/spineboy_starling.png")]
		public var spineboySpriteSheetImage:Class;
	}
}