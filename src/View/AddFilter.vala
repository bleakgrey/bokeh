using Gtk;

public class App.View.AddFilter : Box {

	protected Adw.HeaderBar header;
	public SearchEntry search;

	construct {
		orientation = Orientation.VERTICAL;
		width_request = 500;
		height_request = 400;

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
	}

}
