using Gsk;
using Gtk;

public class App.FilterLayer : Layer {

	public string? asset_id { get; set; }
	public HashTable<string,string> uniforms = new HashTable<string,string> (str_hash, str_equal);

	int _needs_textures = 0;

	public Filter get_asset () {
		return library.asset_cache.get (asset_id) as Filter;
	}

	public override void start_snapshot (Gtk.Snapshot snapshot, Graphene.Rect bounds, App.View.Canvas canvas) {
		_needs_textures = 0;

		var asset = get_asset ();
		var glshader = asset.instance;
		var args = asset.build_args (this.uniforms);
		_needs_textures = glshader.get_n_textures ();
		//warning ("Textures for this layer: "+_needs_textures.to_string ());

		snapshot.push_gl_shader (glshader, bounds, args);
	}

	public override void end_snapshot (Gtk.Snapshot snapshot, Graphene.Rect bounds, App.View.Canvas canvas) {
		for (uint i = 0; i < _needs_textures; i++ ) {
			snapshot.gl_shader_pop_texture ();
		}
		snapshot.pop ();
	}

	public override void build_options (Widget.LayerRow row) {
		var asset = get_asset ();
		asset.uniforms.foreach ((name, uniform) => {
			row.add (get_uniform_controller (uniform));
		});
	}

	Gtk.Widget? get_uniform_controller (Filter.Uniform uniform) {
		var row = new Adw.ActionRow () {
			title = uniform.title
		};

		switch (uniform.holds) {
			case "float":
				double min = double.parse (uniform.min);
				double max = double.parse (uniform.max);
				double step = 0.1;
				double def = double.parse (uniform.default);

				var slider = new Scale.with_range (Orientation.HORIZONTAL, min, max, step) {
					hexpand = true,
					width_request = 150
				};
				var adj = slider.get_adjustment ();
				adj.value_changed.connect (() => {
					var nval = adj.value.to_string ();
					uniforms[uniform.name] = nval;
					render ();
				});

				adj.value = def;
				row.add_suffix (slider);
				break;
		}

		return row;
	}

}
