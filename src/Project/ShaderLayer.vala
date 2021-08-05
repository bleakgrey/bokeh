using Gsk;

public class App.ShaderLayer : Layer {

	protected int needs_textures = 0;

	public string? shader_name { get; set; }

	public Shader get_shader_preset () {
		return library.asset_cache.get (shader_name) as Shader;
	}

	public Bytes get_node_arguments (GLShader shader) {
		var builder = new ShaderArgsBuilder (shader, null);
		return builder.to_args ();
	}

	public override void start_snapshot (Gtk.Snapshot snapshot, Graphene.Rect bounds, App.View.Canvas canvas) {
		needs_textures = 0;

		if (!visible) {
			snapshot.push_debug ("");
			return;
		}

		// var preset = get_shader_preset ();
		// var node = preset.get_node ();
		// var node_args = get_node_arguments (node);
		// snapshot.push_gl_shader (node, bounds, node_args);
		// canvas.snapshot_child (canvas.child, snapshot);
		// snapshot.gl_shader_pop_texture ();
		// snapshot.pop ();

		var preset = get_shader_preset ();
		needs_textures = preset.get_node ().get_n_textures ();
		warning ("Textures for this layer: "+needs_textures.to_string ());

		var node = preset.get_node ();
		var node_args = get_node_arguments (node);
		snapshot.push_gl_shader (node, bounds, node_args);

	}

	public override void reached_root_snapshot (Gtk.Snapshot snapshot, Graphene.Rect bounds, App.View.Canvas canvas) {
		canvas.snapshot_child (canvas.child, snapshot);

		if (!visible)
			needs_textures++;
	}

	public override void end_snapshot (Gtk.Snapshot snapshot, Graphene.Rect bounds, App.View.Canvas canvas) {
		for (uint i = 0; i < needs_textures; i++ ) {
			warning ("Popping tex num: "+i.to_string ());
			snapshot.gl_shader_pop_texture ();
		}
		snapshot.pop ();
	}

}
