using Gtk;

public class App.View.AddFilter : Box {

	public signal void selected (Asset asset);

	protected Adw.HeaderBar header;
	public SearchEntry search;

	protected ScrolledWindow scroller;
	protected GridView grid;
	protected SelectionModel model;

	construct {
		orientation = Orientation.VERTICAL;
		hexpand = true;
		vexpand = true;
		height_request = 300;
		width_request = 500;

		search = new SearchEntry () {
			width_request = 300
		};

		header = new Adw.HeaderBar () {
			title_widget = search,
			show_end_title_buttons = false,
			show_start_title_buttons = false
		};
		//header.add_css_class ("flat");
		append (header);

		scroller = new ScrolledWindow () {
			vexpand = true
		};
		append (scroller);

		model = new SingleSelection (library.assets);
		grid = build_grid ();
		grid.activate.connect (on_selected);
		scroller.child = grid;
	}

	void on_selected (uint pos) {
		var item = model.get_item (pos) as Asset;
		model.unselect_all ();
		selected (item);
	}

	GridView build_grid () {
		var factory = new SignalListItemFactory ();
		factory.setup.connect (widget => {
			var item = new Item ();
			widget.child = item;
		});
		factory.bind.connect (widget => {
			var item = widget.child as Item;
			var asset = widget.item as Shader;
			item.label.label = asset.name;
		});

		return new GridView (model, factory) {
			enable_rubberband = false,
			min_columns = 3,
			max_columns = 3,
			single_click_activate = true
		};
	}

	protected class Item : Box {

		public Picture thumbnail;
		public Label label;

		construct {
			orientation = Orientation.VERTICAL;
			height_request = 120;
			width_request = 100;

			thumbnail = new Picture () {
				valign = Align.FILL,
				halign = Align.FILL,
				hexpand = true,
				vexpand = true,
				can_shrink = true,
				keep_aspect_ratio = false,
				file = File.new_for_path ("/home/user/Downloads/indавex.jpeg"),
				overflow = Overflow.HIDDEN
			};
			append (thumbnail);

			label = new Label ("Label") {
				wrap_mode = Pango.WrapMode.WORD_CHAR,
				single_line_mode = true
			};
			label.add_css_class ("body");
			append (label);
		}

	}

}
