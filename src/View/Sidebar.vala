using Gtk;

public class App.View.Sidebar : View.Base {
	
	protected MenuButton add_button;

	protected View.AddFilter view;
	protected Popover popover;

	construct {
		width_request = 340;
		add_css_class ("view");
		header_title.title = _("Filters");

		view = new View.AddFilter ();

		var frame = new Frame (null) {
			child = view
		};

		popover = new Popover () {
			child = frame,
			default_widget = view.search
		};

		add_button = new MenuButton () {
			popover = popover,
			label = _("New")
			// icon_name = "list-add-symbolic"
		};
		header.pack_start (add_button);
	}
	
}
