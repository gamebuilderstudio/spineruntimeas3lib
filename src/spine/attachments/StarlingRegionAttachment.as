/*******************************************************************************
 * GameBuilder Studio
 * Copyright (C) 2012 GameBuilder Inc.
 * For more information see http://www.gamebuilderstudio.com
 *
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package spine.attachments
{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import spine.Bone;
	import spine.Slot;
	import spine.utils.MathUtils;
	
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/** Attachment that displays a Starling texture region. */
	public class StarlingRegionAttachment extends RegionAttachment {

		protected var _texture : Texture;
		protected var _image : Image;
		
		public function StarlingRegionAttachment (name : String) : void {
			super(name);
		}
		
		override public function draw (displayObject : *, slot : Slot) : void {
			if (_texture == null) throw new Error("RegionAttachment is not setup: " + this);
			
			var batch : QuadBatch = displayObject as QuadBatch;
			if(!_image){
				_image = new Image(_texture);
			}
			
			updateWorldPosition(slot.bone, slot.skeleton.flipX, slot.skeleton.flipY);
			
			var centerX : Number = this.width/2;
			var centerY : Number = this.height/2;
				
			/*_image.width = this.width;
			_image.height = this.height;*/
			_image.pivotX = centerX;
			_image.pivotY = centerY;
			
			_image.x = this._worldX;
			_image.y = this._worldY;
			_image.rotation = MathUtils.getRadiansFromDegrees(this._worldRotation);
			_image.scaleX = this._worldScaleX;
			_image.scaleY = this._worldScaleY;
			
			batch.addImage(_image);
		}
		
		public function set texture (texture : Texture) : void {
			if (texture == null) throw new Error("Texture cannot be null.");
			_texture = texture;
		}
		
		public function get texture () : Texture {
			if (_texture == null) throw new Error("RegionAttachment is not resolved: " + this);
			return _texture;
		}
		
	}
}