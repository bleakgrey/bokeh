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
		//warning ("snap");
		base.snapshot (snapshot);
		if (project != null) {
			var bounds = Graphene.Rect ();
			bounds.init (0, 0, this.get_width (), this.get_height ());

			var layers = project.layers;
			for (uint i = 0; i < layers.get_n_items (); i++ ) {
				var layer = layers.get_object (i) as Layer;
				layer.snapshot (snapshot, bounds, this);
			}
		}
	}

}
