# Bando-Elevator

Bando-Elevator is a versatile (open source) elevator system script for FiveM servers, offering seamless integration with QB-Core and support for both QB and BS menu systems.

## Features

- Support for multiple elevators with configurable floors
- Integration with QB-Core for job-based access control
- Compatibility with both QB and BS menu systems
- Option for car elevators
- Customizable notifications (QB, BS, or none)
- Optional QB-Target integration
- Advanced access control based on jobs, items, and Citizen ID (CID)

## Installation

1. Download the script and place it in your server's `resources` folder.
2. Add `ensure Bando-Elevator` to your `server.cfg` file.
3. Configure the `config.lua` file to set up your elevators and preferences.

## Dependencies

This script requires:
- QB-Core framework

Optional dependencies (based on your configuration):
- bs-menu or qb-menu
- bs-notify or qb-notify
- qb-target

### Configuring Dependencies

The `fxmanifest.lua` file is set up with the default optional dependencies. By default, this script is configured to work with bs-menu and bs-notify. Here's how the `optionals` section in `fxmanifest.lua` looks by default:

```lua
-- Optional dependencies
optionals {
    --'qb-menu',
    'bs-menu',
    --'qb-notify',
    'bs-notify',
    'qb-target'
}
```
To change which systems the script uses:

Open `fxmanifest.lua` and locate the `optionals` section.

Comment out a line by adding -- at the start

Uncomment a line by removing -- from the start

For example, to switch to QB systems:

```lua
-- Optional dependencies
optionals {
    'qb-menu',
    --'bs-menu',
    'qb-notify',
    --'bs-notify',
    'qb-target'
}
```


## Configuration

Remember to also update your [config.lua](config.lua) to match your chosen systems:

```lua
Config.MenuSystem = 'qb'  -- Change to 'qb' if using qb-menu, or 'bs' if using bs-menu
Config.NotifySystem = 'qb'  -- Change to 'qb' if using qb-notify, or 'bs' if using bs-notify
```

Open `config.lua` and adjust the following settings:

- `Config.UseQBTarget`: Set to `true` to use QB-Target, `false` to use default interaction.

- `Config.MenuSystem`: Choose between 'qb' or 'bs' for the menu system.

- `Config.NotifySystem`: Choose between 'qb', 'bs', or 'none' for notifications.

- `Config.Elevators`: Configure your elevators here. Example:

```lua
Config.Elevators = {
    ["MainElevator"] = {
        name = "Main Building Elevator",
        isCarElevator = false,
        floors = {
            {name = "Ground Floor", coords = vector3(x, y, z), heading = 0.0},
            {name = "First Floor", coords = vector3(x, y, z), heading = 0.0},
            -- Add more floors as needed
        },
        access = {
            jobs = {"police", "ambulance"},
            items = {"access_card"},
            cid = {"ABC123", "DEF456"}
        }
    },
    -- Add more elevators as needed
}
```

## Access Restrictions

You can restrict access to elevators based on jobs, items, and Citizen ID (CID):

- `jobs`: List of job names that are allowed to use the elevator.
- `items`: List of items that a player must possess to use the elevator.
- `cid`: List of Citizen IDs that are allowed to use the elevator.

Players must meet at least one of the criteria (job, item, or CID) to access the elevator. If no restrictions are specified, the elevator will be accessible to everyone.

## Usage

Players can interact with the elevator by approaching the configured coordinates. If using QB-Target, players can use the target option to open the elevator menu. The script will automatically check if the player meets the access requirements before allowing them to use the elevator.

## Dependencies

- QB-Core framework
- qb-menu or bs-menu (depending on your configuration)
- qb-target (optional)

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## Support

For support, please open an issue on the GitHub repository or join the Discord (https://discord.gg/Z4rcWvNM).


## Coming Soon

Elevator Sounds: Immersive audio for a more realistic experience.

Multi-Language Support: Use the elevator in your preferred language.
    
Custom UI: A sleek, new interface for elevator controls.

We're always looking to improve! Have suggestions? Let us know!
