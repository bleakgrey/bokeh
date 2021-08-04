using Gtk;

public class App.Window.Main : Adw.Window {

	Project? _project;
	public Project? project {
		get { return this._project; }
		set {
			this._project = value;
			on_project_changed ();
		}
	}
	
	protected Adw.Flap flap_widget;
	protected App.View.Editor editor;
	protected App.View.Sidebar sidebar;

	protected CssProvider css_provider = new CssProvider ();

	construct {
		css_provider.load_from_resource (@"$(Build.RESOURCES)app.css");
		StyleContext.add_provider_for_display (Gdk.Display.get_default (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

		notify["project"].connect (on_project_changed);

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
		on_project_changed ();

		load_project (File.new_for_path ("/home/user/Downloads/tumblr_nm6h3gxZvK1rbc4bko1_640.png"));
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

	void on_project_changed () {
		var is_empty = project == null;

		editor.project = project;
		sidebar.project = project;
		
		flap_widget.locked = is_empty ? true : false;
		flap_widget.reveal_flap = !is_empty;
		update_controls ();
	}

	public void open_file () {
		var filter = new FileFilter () {
			name = _("Graphic Files")
		};
		filter.add_pixbuf_formats ();

		var chooser = new FileChooserNative (_("Open"), this, Gtk.FileChooserAction.OPEN, null, null);
		chooser.add_filter (filter);
		chooser.response.connect (id => {
			switch (id) {
				case -3:
					var selected_file = chooser.get_file ();
					load_project (selected_file);
					break;
			}
			chooser.unref ();
		});
		chooser.ref ();
		chooser.show ();
	}

	public void load_project (File? file) {
		message ("Loading project: "+file.get_path ());
		this.project = new Project (file);
	}

}
