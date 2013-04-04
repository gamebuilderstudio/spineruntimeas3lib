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
	import com.pblabs.rendering2D.spritesheet.TexturePackerSheetDivider;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import spine.Attachment;
	import spine.AttachmentLoader;
	import spine.AttachmentTypeEnum;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Basic2DAttachmentLoader implements AttachmentLoader {
		private var _divider : TexturePackerSheetDivider;
		private var _image : BitmapData;
		
		public function Basic2DAttachmentLoader (divider : TexturePackerSheetDivider, image : BitmapData) : void {
			if (divider == null) throw new Error("divider cannot be null.");
			this._divider = divider;
			this._image = image;
		}
		
		public function newAttachment (type : AttachmentTypeEnum, name : String) : Attachment {
			if(!type)
				type = AttachmentTypeEnum.REGION;
			
			var attachment : Attachment = null;
			switch (type) {
				case AttachmentTypeEnum.REGION:
					attachment = new Basic2DRegionAttachment(name);
					break;
				default:
					throw new Error("Unknown attachment type: " + type.name);
			}
			
			if (attachment is Basic2DRegionAttachment) {
				var region : Rectangle = _divider.getFrameByName(attachment.name);
				if (region == null)
					throw new Error("Region not found in sprite sheet: " + attachment + " (" + type + " attachment: " + name + ")");
				(attachment as Basic2DRegionAttachment).region = region;
				(attachment as Basic2DRegionAttachment).image = _image;
			}
			
			return attachment;
		}
	}
}