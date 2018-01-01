# Halcyon Stats

## Overview

**Halcyon Stats** is a simple online tool that looks up a players in-game stats in Vainglory, a mobile MOBA. Inspired by my passion for the game and the recent release of the Vainglory API. This project's goal is to familiarize myself with Rails, Javascript, Chart.js, and Bootstrap.

## Gems used

* [vainglory-api](https://github.com/cbortz/vainglory-api-ruby)
* [Bootstrap for Sass](https://github.com/twbs/bootstrap-sass)
* [rb-readline](https://github.com/ConnorAtherton/rb-readline) - used to run rails console
* [rails-erd](https://github.com/voormedia/rails-erd) - helpful for organizing associations

## Configuration

Add your API key in app/controllers/application_controller.rb file.
**NOTE:** Should move this configuration in the `config` folder.

## Updating notes
This was last updated in **Version 2.11**.

If v2.11+, go download the new [assets](https://github.com/gamelocker/vainglory-assets.git) and drag them into the app/assets/images/ directory. Make sure the names of the file are hyphenated.

### Future plans
I plan to update this project as the game itself updates. Here are some of the things I plan to do in the future:

#### Known bugs
- [ ] Player data do not update once saved into database (e.g. player skill tier does not change after initialization)
- [ ] Head to head graph does not display stats with the value 0
- [ ] Page elements become out of order when resizing window

#### To do list
- [ ] Friendly and attractive UI
- [ ] Implement loading bar to navbar
- [ ] Clean up code
- [ ] Upload screenshots to this README
- [ ] Match details should display information from participants instead of respective players
- [ ] Use ActiveRecord query to collect stats rather than looping through every match
