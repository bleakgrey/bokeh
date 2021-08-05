using Gtk;

public class App.View.Canvas : Adw.Bin {

	public Project? project { get; set; }

	Picture picture;

	construct {
		notify["project"].connect (on_project_changed);

		picture = new Picture () {
			halign = Align.CENTER,
			valign = Align.CENTER
		};
		child = picture;
	}

	void on_project_changed () {
		picture.file = project == null ? null : project.source_file;
	}

	public override void snapshot (Snapshot snapshot) {
		if (project == null || project.layers.get_n_items () < 1) {
			base.snapshot (snapshot);
			return;
		}

		Graphene.Rect bounds;
		this.child.compute_bounds (this, out bounds);

		//var bounds = Graphene.Bounds ();
		//bounds.init (0, 0, this.child.get_width (), this.child.get_height ());

		warning ("=== BEGIN RENDER ====");

		var layers = project.layers;
		Layer? layer = null;
		for (uint i = 0; i < layers.get_n_items (); i++ ) {
			layer = layers.get_object (i) as Layer;
			warning ("start snap layer: "+layer.name);
			layer.start_snapshot (snapshot, bounds, this);
		}

		if (layer != null) {
			warning ("EMBED CHILD");
			layer.reached_root_snapshot (snapshot, bounds, this);
		}

		for (uint i = 0; i < layers.get_n_items (); i++ ) {
			warning ("end:"+layer.name);
			layer.end_snapshot (snapshot, bounds, this);
		}

	}

}
