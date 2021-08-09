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
		height_request = 400;
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
			item.bind (widget.item as Filter);
		});

		return new GridView (model, factory) {
			enable_rubberband = false,
			min_columns = 3,
			max_columns = 3,
			single_click_activate = true
		};
	}

	protected class Item : Box {

		public Thumbnail thumbnail;
		public Label label;

		construct {
			orientation = Orientation.VERTICAL;
			set_size_request (120, 120);

			thumbnail = new Thumbnail ();
			append (thumbnail);

			label = new Label ("Label") {
				wrap_mode = Pango.WrapMode.WORD_CHAR,
				single_line_mode = true
			};
			label.add_css_class ("body");
			append (label);
		}

		public void bind (Filter asset) {
			label.label = asset.name;
			thumbnail.file = File.new_for_uri ("resource:///com/github/bleakgrey/bokeh/thumb.jpg");
			thumbnail.filter = asset;
			thumbnail.args = asset.get_thumbnail_args ();
		}

	}

	protected class Thumbnail : Adw.Bin {

		public Filter? filter { get; set; }
		public HashTable<string, string> args;

		Picture? pic {
			get { return child as Picture; }
		}

		public File file {
			get { return pic.file; }
			set { pic.file = value; }
		}

		construct {
			child = new Picture () {
				can_shrink = true,
				keep_aspect_ratio = false,
				vexpand = true,
				hexpand = true
			};
			hexpand = true;
			vexpand = true;
			overflow = Overflow.HIDDEN;
			add_css_class ("shader-thumb");
		}

		public override void snapshot (Snapshot snapshot) {
			if (filter == null) {
				return;
			}

			var instance = filter.instance;
			Graphene.Rect bounds;
			compute_bounds (child, out bounds);

			snapshot.push_gl_shader (instance, bounds, filter.build_args (args));
			snapshot_child (child, snapshot);
			snapshot.gl_shader_pop_texture ();
			snapshot.pop ();
		}

	}

}
