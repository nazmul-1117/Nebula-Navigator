# Nebula Navigator

**Nebula Navigator** is a terminal-based star catalog management system developed in Bash. It allows users to add, view, search, edit, delete, and sort stars based on various attributes, all while providing a user-friendly interface with color-coded outputs.

## Features

* **User Authentication**: Secure login system with username and password validation.
* **Star Management**: Add, view, edit, and delete star records.
* **Search Functionality**: Locate stars by exact name match.
* **Distance Sorting**: Sort and display stars by distance in light years.
* **Color-Coded Interface**: Enhanced terminal UI with color highlights for better readability.

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/nazmul-1117/Nebula-Navigator.git
   cd Nebula-Navigator/src
   ```

2. Ensure the script has execute permissions:

   ```bash
   chmod +x nebula_navigator.bash
   ```

3. Run the script:

   ```bash
   ./nebula_navigator.bash
   ```

## Usage

Upon execution, the script presents a login menu. After successful authentication, users can access the main menu with the following options:

1. **Add New Star**: Input details to add a new star to the catalog.
2. **View All Stars**: Display a list of all recorded stars.
3. **Search Star by Name**: Find a star by its exact name.
4. **Edit Star Info**: Modify details of an existing star.
5. **Delete Star**: Remove a star from the catalog.
6. **Show Distance of a Star**: View and sort stars by their distance in light years.
7. **Logout**: Exit the current session.
8. **Exit**: Close the application.

## File Structure

* `nebula_navigator.bash`: Main script file containing all functionalities.
* `data.txt`: Stores star records in the format `ID|Name|Type|Distance|Description`.
* `users.txt`: Contains user credentials in the format `Username|Password`.

## Dependencies

* Bash shell (version 4.0 or higher recommended)
* `column` command-line utility (for formatted output)

## License

This project is licensed under the MIT License.