//Util.as
//Provides a set of utility functions for use throughout the code.

package {
	public static final PIXELS_PER_TILE:int = 32;
	public static final NORTH:int = 0;
	public static final SOUTH:int = 1;
	public static final EAST:int = 2;
	public static final WEST:int = 3;
	public static final DIRECTIONS:Array = new Array(NORTH, SOUTH, EAST, WEST);

	public static grid_to_real(coordinate:int) {
		return coordinate * PIXELS_PER_TILE;
	}
	
	public static real_to_grid(coordinate:int) {
		return coordinate / PIXELS_PER_TILE;
	}
}