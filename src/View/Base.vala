using Gtk;

public class App.View.Base : Box {

	protected Adw.HeaderBar header;
	public Adw.WindowTitle header_title;
	protected Box content;
	
	public string subtitle { get; set; default = ""; }
	public bool show_controls { get; set; default = false; }
	
	construct {
		orientation = Orientation.VERTICAL;
	
		header_title = new Adw.WindowTitle ("", "");
		header = new Adw.HeaderBar () {
			title_widget = header_title
		};
		header.add_css_class ("flat");
		bind_property ("show-controls", header, "show-end-title-buttons", GLib.BindingFlags.SYNC_CREATE);
		bind_property ("show-controls", header, "show-start-title-buttons", GLib.BindingFlags.SYNC_CREATE);
		append (header);
		
		content = new Box (Orientation.VERTICAL, 0);
		append (content);
	}

}
