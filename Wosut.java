import java.io.File;
import java.util.Set;
import java.util.TreeSet;

/**
 * Wosut -- Which operating system used this?
 * 
 * @author Urs Schmidt
 *
 */
public class Wosut {

	public enum OperatingSystem {
		ANDROID, MACINTOSH, UBUNTU, WINDOWS
	}

	/**
	 * This method determines which operating systems might have been using a
	 * given directory.
	 * 
	 * @param directory
	 *            The directory to be checked. Typically a USB flash drive.
	 * @param recursive
	 *            Whether to check the directory recursively.
	 * @return A set of operating systems that might have used the given
	 *         directory.
	 */
	private static Set<OperatingSystem> checkDirectory(File directory, boolean recursive) {
		Set<OperatingSystem> result = new TreeSet<>();
		for (File file : directory.listFiles()) {
			String n = file.getName();

			/* Android */
			if (n.equals("customized-capability.xml") //
					|| n.equals("default-capability.xml") //
					|| n.equals("LOST.DIR")) {
				result.add(OperatingSystem.ANDROID);
			}

			/* Macintosh */
			else if (n.equals(".DS_Store") || n.equals("._.DS_Store") //
					|| n.equals("__MACOSX") //
					|| n.equals(".Spotlight-V100") //
					|| n.equals(".TemporaryItems") || n.equals("._.TemporaryItems") //
					|| n.equals(".Trashes") || n.equals("._.Trashes") //
					|| n.equals(".fseventsd")) {
				result.add(OperatingSystem.MACINTOSH);
			}

			/* Ubuntu */
			else if (n.startsWith(".Trash-") //
					|| n.equals("lost+found")) {
				result.add(OperatingSystem.UBUNTU);
			}

			/* Windows */
			else if (n.equalsIgnoreCase("autorun.inf") //
					|| n.equalsIgnoreCase("desktop.ini") //
					|| n.equalsIgnoreCase("$RECYCLE.BIN") //
					|| n.equalsIgnoreCase("System Volume Information") //
					|| n.equalsIgnoreCase("Thumbs.db")) {
				result.add(OperatingSystem.WINDOWS);
			}

			if (recursive && file.isDirectory()) {
				result.addAll(checkDirectory(file, true));
			}
		}
		return result;
	}

	/**
	 * An example implementation.
	 * 
	 * @param args
	 *            The pathname of the directory. You can additionally pass "-r"
	 *            to check the directory recursively.
	 */
	public static void main(String[] args) {
		String pathname = ".";
		boolean recursive = false;
		for (String arg : args) {
			if (arg.equals("-r")) {
				recursive = true;
			} else {
				pathname = arg;
			}
		}
		for (OperatingSystem os : checkDirectory(new File(pathname), recursive)) {
			System.out.println(os);
		}
	}

}
