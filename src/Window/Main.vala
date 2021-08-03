using Gtk;

public class App.Window.Main : Adw.Window {

	public File? file { get; set; }
	
	protected Adw.Flap flap_widget;
	protected App.View.Editor editor;
	protected App.View.Sidebar sidebar;

	protected CssProvider css_provider = new CssProvider ();

	construct {
		css_provider.load_from_resource (@"$(Build.RESOURCES)app.css");
		StyleContext.add_provider_for_display (Gdk.Display.get_default (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

		notify["file"].connect (on_file_change);

		editor = new View.Editor (this);
		sidebar = new View.Sidebar ();
	
		flap_widget = new Adw.Flap () {
			content = editor,
			flap = sidebar,
			separator = new Separator (Orientation.VERTICAL),
			flap_position = PackType.END,
			reveal_flap = false,
			locked = true
		};

		flap_widget.notify["reveal_flap"].connect (update_controls);
		flap_widget.notify["folded"].connect (update_controls);
		update_controls ();
		
		set_child (flap_widget);
	}
	
	public class Main () {
		Object (
			width_request: 360,
			height_request: 500,
			default_width: 1100
		);
		
		present ();
		on_file_change ();
	}

	void update_controls () {
		if (!flap_widget.reveal_flap) {
			editor.show_controls = true;
			return;
		}
		else {
			editor.show_controls = flap_widget.folded;
			sidebar.show_controls = !flap_widget.folded;
		}
	}

	void on_file_change () {
		var is_empty = file == null;
		
		editor.file = file;
		flap_widget.locked = is_empty ? true : false;
		flap_widget.reveal_flap = !is_empty;
		update_controls ();
	}
	
}
