/*******************************************************************************
 * GameBuilder Studio
 * Copyright (C) 2012 GameBuilder Inc.
 * For more information see http://www.gamebuilderstudio.com
 *
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package spine
{
	import spine.Slot;
	
	/**
	 * Base attachment class for all Spine skin attachments
	 **/
	public class Attachment {
		protected var _name : String;
		
		public function Attachment (name : String) {
			if (name == null) throw new Error("name cannot be null.");
			this._name = name;
		}

		public function draw (displayObject : *, slot : Slot):void
		{
			throw new Error("Draw method should be implemented by subclasses");
		}
		
		public function get name () : String {
			return _name;
		}
		
		public function toString () : String{
			return _name;
		}
	}
}
