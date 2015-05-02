//Util.as
//Provides a set of utility functions for use throughout the code.

package {
	public static final PIXELS_PER_TILE:int = 32;

	public static grid_to_real(coordinate:int) {
		return coordinate * PIXELS_PER_TILE;
	}
	
	public static real_to_grid(coordinate:int) {
		return coordinate / PIXELS_PER_TILE;
	}
}