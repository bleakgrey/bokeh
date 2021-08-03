using Gtk;

public class App.Window.Main : Adw.Window {

	protected File? file { get; set; }
	
	protected Adw.Flap flap_widget;
	protected App.View.Editor editor;
	protected App.View.Sidebar sidebar;

	construct {
		notify["file"].connect (on_file_change);

		editor = new View.Editor ();
		sidebar = new View.Sidebar ();
	
		flap_widget = new Adw.Flap () {
			content = editor,
			flap = sidebar,
			flap_position = PackType.END,
			separator = new Separator (Orientation.VERTICAL)
		};
		flap_widget.bind_property ("folded", editor, "show-controls", BindingFlags.SYNC_CREATE);
		flap_widget.bind_property ("folded", sidebar, "show-controls", BindingFlags.SYNC_CREATE | BindingFlags.INVERT_BOOLEAN);
		
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

		file = File.new_for_path ("/home/user/Pictures/Screenshot from 2021-07-05 16-18-51.png");
	}



	void on_file_change () {
		if (file == null) {
			editor.header_title.subtitle = null;
			editor.file = null;
			return;
		}
		
		editor.header_title.subtitle = file.get_basename ();
		editor.file = file;
	}
	
}
