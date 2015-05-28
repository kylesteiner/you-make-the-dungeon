package {
	import flash.utils.Dictionary;

	public class Assets {
		public static var animations:Dictionary; // Map String -> Dictionary<String, Vector<Texture>>
		public static var floors:Dictionary;	// Map String -> String
		public static var mixer:Mixer;
		public static var textures:Dictionary;	// Map String -> Texture
	}
}
