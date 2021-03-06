using Gtk;

public class App.View.Editor : View.Base {

	public Window.Main window { get; set; }
	public Project? project {
		get { return canvas.project; }
		set { canvas.project = value; }
	}

	protected Adw.ViewStack stack;
	protected Adw.StatusPage empty_state;
	protected View.Navigator navigator;
	protected View.Canvas canvas;

	protected Button open_button;
	protected Button save_button;
	protected MenuButton menu_button;
	protected Scale zoom_slider;

	public class Editor (Window.Main window) {
		this.window = window;
		this.window.render.connect (() => {
			canvas.queue_draw ();
		});
		notify["project"].connect (on_project_changed);
	}
	
	construct {
		build_header ();

		stack = new Adw.ViewStack ();
		content.append (stack);

		empty_state = new Adw.StatusPage () {
			title = _("Nothing here yet"),
			description = _("Open a photo to start editing"),
			icon_name = Build.DOMAIN+"-symbolic"
		};
		stack.add_named (empty_state, "empty");

		canvas = new View.Canvas ();
		zoom_slider.get_adjustment ().bind_property ("value", canvas, "scale", GLib.BindingFlags.SYNC_CREATE);
		navigator = new View.Navigator (canvas) {
			hexpand = true,
			vexpand = true
		};
		stack.add_named (navigator, "canvas");
	}

	void build_header () {
		menu_button = new MenuButton () {
			icon_name = "open-menu-symbolic"
		};
		menu_button.add_css_class ("flat");
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

		zoom_slider = new Scale.with_range (Orientation.HORIZONTAL, 0.2f, 5.0f, 0.2) {
			width_request = 200
		};
		header.pack_start (zoom_slider);
	}

	void on_open_clicked () {
		window.open_file ();
	}

	void on_project_changed () {
		var is_empty = (project == null);

		stack.visible_child_name = is_empty ? "empty" : "canvas";
		header_title.title = is_empty ? Build.NAME : project.file.get_basename ();
		save_button.visible = !is_empty;

		if (is_empty)
			this.remove_css_class ("editor-bg");
		else
			this.add_css_class ("editor-bg");
	}
	
}
