public class App.Filter : Asset, Json.Serializable {

	public Bytes fragment_shader { get; set; }
	public HashTable<string, Uniform> uniforms { get; set; }

	Gsk.GLShader _instance = null;
	public Gsk.GLShader instance {
		get {
			if (_instance == null)
				_instance = new Gsk.GLShader.from_bytes (fragment_shader);
			return _instance;
		}
	}

	public static Filter parse (File dir) throws Error {
		var id = dir.get_basename ();

		var shader_file = File.new_build_filename (dir.get_path (), "fragment.glsl");
		if (!shader_file.query_exists ())
			throw new FileError.NOENT ("Fragment shader not found");

		var manifest_file = File.new_build_filename (dir.get_path (), "manifest.json");
		if (!manifest_file.query_exists ())
			throw new FileError.NOENT ("Manifest not found");

		var manifest = manifest_file.load_bytes ();
		var manifest_data = (string) manifest.get_data ();

		var filter = Json.gobject_from_data (typeof (Filter), manifest_data) as Filter;
		filter.id = id;
		filter.fragment_shader = shader_file.load_bytes ();
		return filter;
	}

	public virtual bool deserialize_property (string property, out Value val, ParamSpec spec, Json.Node node) {
		switch (property) {
			case "uniforms":
				var table = new HashTable<string, Object> (str_hash, str_equal);

				if (node.get_node_type () == Json.NodeType.OBJECT) {
					node.get_object ().foreach_member ((obj, name, node) => {
						var u = parse_uniform (name, node);
						table[u.name] = u;
					});
				}

				val = table;
				return true;
			default:
				return default_deserialize_property (property, out val, spec, node);
		}
	}

	public Bytes build_args (HashTable<string,string> uniforms) {
		var builder = new Gsk.ShaderArgsBuilder (instance, null);
		uniforms.for_each ((name) => {
			var schema = this.uniforms[name];
			if (schema != null) {
				var idx = instance.find_uniform_by_name (name);
				var val = uniforms[name];

				switch (schema.holds) {
					case "float":
						var fval = double.parse (val);
						builder.set_float (idx, (float) fval);
						break;
				}
			}
		});

		return builder.to_args ();
	}

	public HashTable<string, string> get_thumbnail_args () {
		var args = new HashTable<string, string> (str_hash, str_equal);
		args["amount"] = "1.0";
		args["intensity"] = "1.0";
		return args;
	}



	public class Uniform : Object {

		public string name { get; set; }

		public string title { get; set; }
		public string holds { get; set; }

		public string min { get; set; }
		public string max { get; set; }
		public string default { get; set; }

	}

	protected Uniform parse_uniform ( string name, Json.Node node) throws Error {
		var u = Json.gobject_deserialize (typeof (Uniform), node) as Uniform;
		u.name = name;
		return u;
	}

}
