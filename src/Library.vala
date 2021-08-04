public class App.Library : Object {

	public string path { get; set; }

	public Library (string path) {
		this.path = path;
		message (@"Library is located at: \"$path\"");
	}

	public void load () {

	}

}
