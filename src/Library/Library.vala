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
			load_shader (file);
		}
	}

	protected void load_shader (File dir) {
		var shader_file = File.new_build_filename (dir.get_path (), "fragment.glsl");
		var manifest_file = File.new_build_filename (dir.get_path (), "manifest.json");
		var id = dir.get_basename ();
		message (@"Found shader: \"$id\"");

		try {
			if (!shader_file.query_exists ())
				throw new FileError.NOENT ("Fragment shader not found");

			string etag_out;
			var bytes = shader_file.load_bytes (null, out etag_out);

			var shader = new Shader () {
				id = id,
				name = id,
				content = (owned) bytes
			};

			assets.append (shader);
			asset_cache.set (id, shader);
		}
		catch (Error e) {
			warning (e.message);
		}
	}

}
