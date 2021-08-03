using Gtk;

public class App.View.Sidebar : View.Base {
	
	protected MenuButton add_button;

	protected View.AddFilter view;
	protected Popover popover;

	protected ScrolledWindow scroller;
	protected ListBox list;

	construct {
		width_request = 340;
		show_controls = true;
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
			//label = _("New")
			icon_name = "list-add-symbolic"
		};
		header.pack_start (add_button);

		list = new ListBox ();
		list.add_css_class ("content");

		scroller = new ScrolledWindow () {
			vexpand = true
		};
		scroller.child = list;
		append (scroller);
	}

	public Sidebar () {
		add_item ();
		add_item ();
		add_item ();
	}

	public void add_item () {
		var item = new Widget.LayerRow ();
		list.append (item);
	}
	
}
