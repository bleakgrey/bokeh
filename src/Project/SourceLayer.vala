public class App.SourceLayer : Layer {

	construct {
		icon_name = "image-x-generic-symbolic";
	}

	public override void start_snapshot (Gtk.Snapshot snapshot, Graphene.Rect bounds, App.View.Canvas canvas) {
		snapshot.push_debug ("");
	}

	public override void end_snapshot (Gtk.Snapshot snapshot, Graphene.Rect bounds, App.View.Canvas canvas) {
		snapshot.pop ();
	}

}
