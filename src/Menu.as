package {
    import starling.display.*;
    import starling.events.*;
    import starling.textures.*;

    public class Menu extends Sprite {

        public var items:Array

        public function Menu(displayItems:Array) {
            items = displayItems;
            for each (var item:DisplayObject in items) {
                addChild(item);
            }
        }
    }
}
