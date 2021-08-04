using Gsk;

public class App.ShaderLayer : Layer {

	public string? shader_name { get; set; }

	protected Shader get_shader_preset () {
		return library.shaders.get (shader_name);
	}

	public Bytes get_node_arguments (GLShader shader) {
		var builder = new ShaderArgsBuilder (shader, null);
		return builder.to_args ();
	}

	public override void snapshot (Gtk.Snapshot snapshot, Graphene.Rect bounds, App.View.Canvas canvas) {
		if (!visible)
			return;

		var preset = get_shader_preset ();
		var node = preset.get_node ();
		var node_args = get_node_arguments (node);
		snapshot.push_gl_shader (node, bounds, node_args);
		canvas.snapshot_child (canvas.child, snapshot);
		snapshot.gl_shader_pop_texture ();
		snapshot.pop ();
	}

}
