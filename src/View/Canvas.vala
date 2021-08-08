using Gtk;

public class App.View.Canvas : Adw.Bin {

	public Project? project { get; set; }

	public float scale { get; set; default = 4.0f; }

	public int w = 0;
	public int h = 0;

	public Graphene.Rect source_rect {
		owned get {
			if (project == null) return Graphene.Rect.zero ();

			var p = project.source;
			var rect = Graphene.Rect ();
			return rect.init (0, 0, p.get_intrinsic_width (), p.get_intrinsic_height ());
		}
	}

	public Graphene.Rect target_rect {
		owned get {
			return source_rect.scale (scale, scale);
		}
	}

	public Graphene.Rect visible_rect { get; set; default = Graphene.Rect.zero (); }

	construct {
		notify["project"].connect (on_project_changed);
		notify["scale"].connect (update_zoom);
		notify["visible-rect"].connect (() => queue_draw ());

		hexpand = false;
		vexpand = false;
		halign = Align.START;
		valign = Align.START;
		add_css_class ("canvas");
	}

	void update_zoom () {
		w = (int) (project.source.get_intrinsic_width () * scale);
		h = (int) (project.source.get_intrinsic_height () * scale);
		set_size_request (w, h);
	}

	void on_project_changed () {
		update_zoom ();
	}

	protected void log (string str) {
		warning (str);
	}

	public override void snapshot (Snapshot snapshot) {
		if (project == null) {
			base.snapshot (snapshot);
			return;
		}

		//log ("=== BEGIN RENDER ====");

		var layers = project.layers;
		Layer? last_layer = null;

		for (uint i = 0; i < layers.get_n_items (); i++ ) {
			var layer = layers.get_object (i) as Layer;
			if (layer.visible) {
				//log ("start -> "+layer.name);
				layer.start_snapshot (snapshot, visible_rect, this);
				last_layer = layer;
			}
		}

		if (last_layer != null && last_layer.visible) {
			//log ("EMBED CHILD");
			snapshot.append_texture (project.source, target_rect);
		}

		for (int i = (int)layers.get_n_items ()-1; i != -1; i-- ) {
			var layer = layers.get_object (i) as Layer;
			if (layer.visible) {
				//log ("end -> "+layer.name);
				layer.end_snapshot (snapshot, visible_rect, this);
			}
		}

	}

}
