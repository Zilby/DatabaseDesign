import java.sql.*;
import java.util.*;

//This code was written in java

/* 
**Personal notes to self to run program**

user = root
pw = default(lazy)

To run, use the first line to compile the program and the second
to execute its main function with the appropriate classpath. 

javac -cp mysql-connector-java-5.1.39-bin.jar:. Application.java
java -cp mysql-connector-java-5.1.39-bin.jar:. Application
*/

public class Application {
    private final String serverName = "localhost";
    private final int portNumber = 3306;
    // for my personal use my db is named starwarsfinalzilbershera
    private final String dbName = "starwarsfinal";
    private Scanner sc = new Scanner(System.in);
    private String userName = "root";
    private String password = "root";
    private String character_name = "";
	
    public Connection getConnection() throws SQLException {
	Connection conn = null;
	Properties connectionProps = new Properties();
	connectionProps.put("user", this.userName);
	connectionProps.put("password", this.password);
	conn = DriverManager.getConnection("jdbc:mysql://" + this.serverName
					   + ":" + this.portNumber + "/"
					   + this.dbName, connectionProps);
	return conn;
    }

    public void run() {
	Connection conn = null;
	try {
	    // prompts user for username
	    System.out.println("Username: ");
	    this.userName = sc.nextLine();
	    // prompts user for password
	    System.out.println("Password: ");
	    this.password = sc.nextLine();
	    conn = this.getConnection();
	    System.out.println("Connected to database");
	} catch (SQLException e) {
	    // if given a bad connection it will give the error message below
	    // and prompt you to try again
	    System.out.println("Error: Bad credentials, please try again.");
	    run();
	    return;
	}
	try {
	    Statement stmt = conn.createStatement();
	    // executes query to get character names column
	    ResultSet rs = stmt.executeQuery("SELECT character_name FROM characters");
	    System.out.println("Character name to track: ");
	    character_name = sc.nextLine();
	    boolean invalid = true;
	    // validates your character name
	    while(invalid) {
		while(rs.next()) {
		    if(rs.getString(1).equals(character_name)) {
			invalid = false;
		    }
		}
		if(invalid) {
		    // if given an invalid character name, will display the error message below
		    // and prompt user to try again
		    rs = stmt.executeQuery("SELECT character_name FROM characters");
		    System.out.println("Invalid character name, try again: ");
		    character_name = sc.nextLine();
		}
	    }
	    // executes track_character on our now valid character name
	    rs = stmt.executeQuery("CALL track_character('"+ character_name + "')");
	    // prints our result set
	    String results = "";
	    while(rs.next()) {
		for(int i = 1; i <= rs.getMetaData().getColumnCount() ; i++) {
		    results += rs.getMetaData().getColumnName(i) + ": " + rs.getString(i);
		    if (i < rs.getMetaData().getColumnCount()) {
			results += ", ";
		    }
		}
		results += "\n";
	    }
	    results = results.substring(0,results.length() - 1);
	    System.out.println(results);
	    // closes our connection and ends the program. 
	    stmt.close();
	    conn.close();
	} catch (SQLException e) {
	    System.out.println("ERROR: Encountered exception");
	    e.printStackTrace();
	    return;
	}   
    }
    
    public static void main(String[] args) {
	Application app = new Application();
	app.run();
    }
}
