package tiles.empty {
    import starling.core.Starling;
    import starling.display.*;
    import starling.textures.*;

    import tiles.*;

    public class EmptyTileNSEW extends Tile {
        [Embed(source='/assets/tiles/small/tile_nsew.png')] public var tileImg:Class;

        public function EmptyTileNSEW(x:int, y:int) {
            super(x, y);
            north = true;
            south = true;
            east = true;
            west = true;

            var texture:Texture = Texture.fromBitmap(new tileImg());
            image = new Image(texture);
            addChild(image);
        }
    }
}
