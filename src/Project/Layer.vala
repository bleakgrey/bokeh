public abstract class App.Layer : Object {

	public static uint LAYER_ID_COUNTER = 0;

	// Volatile state
	protected Window.Main? window { get; set; }

	// Serializable state
	public uint id { get; set; default = 0; }
	public string name { get; set; default = _("New Layer"); }
	public bool visible { get; set; default = true; }
	public string icon_name { get; set; default = "layer-arrow-symbolic"; }

	// Class defaults
	public bool removable { get; set; default = true; }
	public bool togglable { get; set; default = true; }

	construct {
		if (this.id == 0) {
			LAYER_ID_COUNTER++;
			this.id = LAYER_ID_COUNTER;
		}
	}

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

	public abstract void start_snapshot (Gtk.Snapshot snapshot, Graphene.Rect bounds, App.View.Canvas canvas);
	public abstract void end_snapshot (Gtk.Snapshot snapshot, Graphene.Rect bounds, App.View.Canvas canvas);

	public void render () {
		this.window.render ();
	}

	public void remove () {
		this.window.project.remove_layer (this);
	}

	public virtual void build_options (Widget.LayerRow row) {}

}
