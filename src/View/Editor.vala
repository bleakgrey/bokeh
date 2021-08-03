using Gtk;

public class App.View.Editor : View.Base {

	protected Button open_button;
	protected Button save_button;
	
	construct {
		header_title.title = Build.NAME;

		open_button = new Button () {
			label = _("Open")
		};
		header.pack_start (open_button);
		
		save_button = new Button () {
			label = _("Save")
		};
		save_button.add_css_class ("suggested-action");
		header.pack_end (save_button);
	}
	
	public class Editor () {
		
	}
	
}
