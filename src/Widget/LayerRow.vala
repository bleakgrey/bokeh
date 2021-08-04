using Gtk;

public class App.Widget.LayerRow : Adw.ExpanderRow {

	protected Layer layer;
	protected Button remove_button;

	construct {
		add_css_class ("heading");

		remove_button = new Button () {
			icon_name = "user-trash-symbolic",
			valign = Align.CENTER
		};
		remove_button.add_css_class ("flat");
		add_action (remove_button);
	}

	public LayerRow (Layer layer) {
		this.layer = layer;
		layer.bind_property ("name", this, "title", GLib.BindingFlags.SYNC_CREATE);
		layer.bind_property ("togglable", this, "show-enable-switch", GLib.BindingFlags.SYNC_CREATE);
		layer.bind_property ("removable", remove_button, "visible", GLib.BindingFlags.SYNC_CREATE);
	}

}
