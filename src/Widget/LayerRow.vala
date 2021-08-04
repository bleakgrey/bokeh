using Gtk;

public class App.Widget.LayerRow : Adw.ExpanderRow {

	protected Layer layer;
	protected Button remove_button;
	protected Switch visiblilty_switch;

	construct {
		add_css_class ("heading");

		visiblilty_switch = new Switch () {
			valign = Align.CENTER,
			state = true
		};
		add_action (visiblilty_switch);

		remove_button = new Button () {
			icon_name = "user-trash-symbolic",
			valign = Align.CENTER
		};
		remove_button.add_css_class ("flat");
		remove_button.clicked.connect (on_remove_pressed);
		add_action (remove_button);
	}

	public LayerRow (Layer layer) {
		this.layer = layer;
		layer.bind_property ("name", this, "title", GLib.BindingFlags.SYNC_CREATE);
		layer.bind_property ("togglable", visiblilty_switch, "visible", GLib.BindingFlags.SYNC_CREATE);
		layer.bind_property ("removable", remove_button, "visible", GLib.BindingFlags.SYNC_CREATE);

		visiblilty_switch.bind_property ("state", layer, "visible", GLib.BindingFlags.SYNC_CREATE);
	}

	void on_remove_pressed () {
		this.layer.remove ();
	}

}
