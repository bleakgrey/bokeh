using Gsk;

public class App.Shader : Asset {

	public Bytes fragment_shader { get; set; }

	public GLShader get_node () {
		return new GLShader.from_bytes (fragment_shader);
	}

	public static Shader parse_shader (File dir) throws Error {
		var id = dir.get_basename ();

		var shader_file = File.new_build_filename (dir.get_path (), "fragment.glsl");
		if (!shader_file.query_exists ())
			throw new FileError.NOENT ("Fragment shader not found");

		var manifest_file = File.new_build_filename (dir.get_path (), "manifest.json");
		if (!manifest_file.query_exists ())
			throw new FileError.NOENT ("Manifest not found");

		var manifest = manifest_file.load_bytes ();
		var manifest_data = (string) manifest.get_data ();

		var shader = Json.gobject_from_data (typeof (Shader), manifest_data) as Shader;
		shader.id = id;
		shader.fragment_shader = shader_file.load_bytes ();

		return shader;
	}

}
