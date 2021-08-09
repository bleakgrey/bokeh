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
		add_button.add_css_class ("flat");
		header.pack_start (add_button);

		list = new ListBox ();
		list.add_css_class ("content");

		scroller = new ScrolledWindow () {
			vexpand = true
		};
		scroller.child = list;
		append (scroller);
	}

	void bind_project () {
		var expression = new PropertyExpression (typeof (App.Layer), null, "id");
		var sorter = new NumericSorter (expression);
		var model = new SortListModel (current_project.layers, sorter);
		list.bind_model (model, (obj) => {
			return new Widget.LayerRow (obj as Layer) {
				expanded = true
			};
		});
	}

	void unbind_project () {
		list.bind_model (null, null);
	}

	void add_asset_instance (Asset asset) {
		popover.popdown ();

		var type = asset.get_class ().get_name ();
		switch (type) {
			case "AppFilter":
				var filter = asset as Filter;
				current_project.add_layer (new FilterLayer () {
					name = filter.name,
					asset_id = filter.id
				});
				break;
		}
	}

}
