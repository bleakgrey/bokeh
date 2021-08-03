using Gtk;

public class App.View.Editor : View.Base {

	public File? file {
		get { return canvas.file; }
		set { canvas.file = value; }
	}

	protected View.Canvas canvas;
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

		canvas = new View.Canvas () {
			hexpand = true,
			vexpand = true
		};
		content.append (canvas);
	}
	
	public class Editor () {
		
	}
	
}
