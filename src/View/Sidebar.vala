using Gtk;

public class App.View.Sidebar : View.Base {
	
	protected MenuButton add_button;

	protected View.AddFilter view;
	protected Popover popover;

	protected ScrolledWindow scroller;
	protected ListBox list;

	Project? current_project = null;
	public Project? project {
		set {
			if (current_project != null)
				unbind_project ();
			current_project = value;

			if (value != null)
				bind_project ();
		}
	}

	void bind_project () {
		list.bind_model (current_project.layers, (obj) => {
			return new Widget.LayerRow (obj as Layer);
		});
	}

	void unbind_project () {
		list.bind_model (null, null);
	}

	construct {
		width_request = 320;
		show_controls = true;
		add_css_class ("app-view");
		add_css_class ("view");
		header_title.title = _("Layers");

		view = new View.AddFilter ();
		view.selected.connect (add_asset_instance);

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
	
	void add_asset_instance (Asset asset) {
		popover.popdown ();

		var type = asset.get_class ().get_name ();
		switch (type) {
			case "AppShader":
				var shader = asset as Shader;
				current_project.add_layer (new ShaderLayer () {
					name = shader.name,
					shader_name = shader.id
				});
				break;
		}
	}

}
