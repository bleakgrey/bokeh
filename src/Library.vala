public class App.Library : Object {

	public string path { get; set; }

	public Gee.HashMap<string,Shader> shaders = new Gee.HashMap<string,Shader>();

	public Library (string path) {
		this.path = path;
		message (@"Library is located at: \"$path\"");

		load ();
	}

	public void load () {
		load_shader (path+"/shaders/sepia/fragment.glsl");
	}

	protected void load_shader (string path) {
		message ("Loading shader: "+path);
		try {
			var file = File.new_for_path (path);

			if (!file.query_exists ())
				throw new FileError.NOENT ("File doesn't exist");

			string etag_out;
			var bytes = file.load_bytes (null, out etag_out);

			var shader = new Shader () {
				name = "sepia",
				content = (owned) bytes
			};

			shaders.set (shader.name, shader);
		}
		catch (Error e) {
			warning (e.message);
		}
	}

}
