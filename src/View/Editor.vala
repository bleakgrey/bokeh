using Gtk;

public class App.View.Editor : View.Base {

	public Window.Main window { get; set; }
	public File? file {
		get { return canvas.file; }
		set { canvas.file = value; }
	}

	protected Adw.ViewStack stack;

	protected Adw.StatusPage empty_state;

	protected View.Canvas canvas;
	protected Button open_button;
	protected Button save_button;
	protected MenuButton menu_button;

	public class Editor (Window.Main window) {
		this.window = window;
		notify["file"].connect (on_file_changed);
	}
	
	construct {
		build_header ();

		stack = new Adw.ViewStack ();
		content.append (stack);

		empty_state = new Adw.StatusPage () {
			title = _("Nothing here yet"),
			description = _("Open a photo to start editing")
		};
		stack.add_named (empty_state, "empty");

		canvas = new View.Canvas () {
			hexpand = true,
			vexpand = true
		};
		stack.add_named (canvas, "canvas");
	}

	void build_header () {
		header_title.title = Build.NAME;

		menu_button = new MenuButton () {
			icon_name = "open-menu-symbolic"
		};
		header.pack_end (menu_button);

		save_button = new Button () {
			label = _("Save")
		};
		save_button.add_css_class ("suggested-action");
		header.pack_end (save_button);

		open_button = new Button () {
			label = _("Open")
		};
		open_button.clicked.connect (on_open_clicked);
		header.pack_start (open_button);
	}

	void on_open_clicked () {
		window.open_file ();
	}

	void on_file_changed () {
		var is_empty = (file == null);
		stack.visible_child_name = is_empty ? "empty" : "canvas";
		header_title.subtitle = is_empty ? "" : file.get_basename ();
		save_button.visible = !is_empty;
	}
	
}
