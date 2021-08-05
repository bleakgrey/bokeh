public class App.Layer : Object {

	// Volatile state
	protected Window.Main? window { get; set; }

	// Serializable state
	public string name { get; set; default = _("New Layer"); }
	public bool visible { get; set; default = true; }

	// Class defaults
	public bool removable { get; set; default = true; }
	public bool togglable { get; set; default = true; }

	public virtual signal void on_added (Window.Main? win) {
		message ("Bind layer to window");
		this.window = win;
		notify["visible"].connect (render);
		render ();
	}
	public virtual signal void on_removed () {
		message ("Unbind layer from window");
		this.visible = false;
		render ();
		this.window = null;
		notify["visible"].disconnect (render);
	}

	public virtual void snapshot (Gtk.Snapshot snapshot, Graphene.Rect bounds, App.View.Canvas canvas) {}

	public void render () {
		this.window.render ();
	}

	public void remove () {
		this.window.project.remove_layer (this);
	}

}
