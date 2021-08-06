public class App.Library : Object {

	public string path { get; set; }

	public Gee.HashMap<string,Asset> asset_cache = new Gee.HashMap<string,Asset>();
	public ListStore assets = new ListStore (typeof (Asset));

	public Library (string path) {
		this.path = path;
		message (@"Library is located at: \"$path\"");

		load_bundle (path);
	}

	public void load_bundle (string path) {
		load_assets (File.new_for_path (path));
		//load_shader (path+"/shaders/sepia/fragment.glsl");
	}

	protected void load_assets (File root) throws Error {
		var enumerator = root.enumerate_children ("standard::*", FileQueryInfoFlags.NONE, null);

		File[] shader_dirs = {};

		FileInfo info = null;
		while ( ((info = enumerator.next_file (null)) != null) ) {
			if (info.get_file_type () == FileType.DIRECTORY) {
				File subdir = root.resolve_relative_path (info.get_name ());
				shader_dirs += subdir;
			}
		}

		foreach (var file in shader_dirs) {
			var id = file.get_basename ();
			message (@"Loading asset \"$id\"");
			try {
				var asset = Shader.parse_shader (file);
				assets.append (asset);
				asset_cache.set (id, asset);
			}
			catch (Error e) {
				warning (@"Failed to load asset \"$id\": $(e.message)");
			}
		}
	}

}
