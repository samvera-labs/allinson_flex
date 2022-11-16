# Allinson Flex - A Flexible Machine-readable Metadata Modeling Implementation

This library implements the M3 specifications found in [Houndstooth](https://github.com/samvera-labs/houndstooth) for Hyrax and other Samvera repository systems. It is able to read an M3 schema along with a profile YAML file and provides a graphical interface for editing the classes, contexts, mappings and properties found with in. It then provides hooks to the various pieces of Hyrax and similar Rails based systems to in order to assign contexts to Admin Sets, create and modify works and have all the properties of that work defined dynamically by users during run time. Work Types must exists in code (there is a work type generator), but all properties within can be edited dynamically by the library and are stored as data.


Overview/intro to flex [graphic](https://repo.samvera.org/concern/images/3a052332-11db-4b4a-9356-ae0291ec096f?locale=en#?c=0&m=0&s=0&cv=0&xywh=-1475%2C0%2C5449%2C1875) Note that Flexible Metadata for FileSets and Collections is currently not supported.
![Allinson_Flex_Poster](https://user-images.githubusercontent.com/10081604/195655778-2d23cba2-fb81-4da9-8a24-cf66c82b1741.jpg)

## Installing

### Install Generator

Add this line to your application's Gemfile:

```ruby
gem 'allinson_flex', git: 'https://github.com/samvera-labs/allinson_flex.git'
```

And then execute:
```bash
$ bundle install
$ rails generate allinson_flex:install
$ rails db:migrate
```

AllinsonFlex uses webpacker and React JS (via the react-rails gem).

Please run the following if they are not already installed in your application.
Note: If running a docker container, these need to be installed outside of the container in order to find the github ssh links.

```bash
$ rails webpacker:install
$ rails webpacker:install:react
$ rails generate react:install
```

Add to app/assets/stylesheets/application.css

```css
 *= require allinson_flex/application
```

and to app/assets/javascripts/application.js

```js
//= require allinson_flex/application
```

### Set up profiles and classes

Open the app in a browser and navigate to the Hyrax Dashboard > Metadata Profiles
and click Import Profile. You can select the example profile in config/metadata_profile/hyrax.yaml

### Create work types

The work type installer can run over existing work models or generate new ones.

Add or modify all existing work types, based on Hyrax curation concerns or Dynamic Shemas:

```bash
$ rails generate allinson_flex:works
```

To run the generator against specific models, pass the command a model_name argument like:

```bash
$ rails generate allinson_flex:works Image
```

You can pass it multiple arguments for mulitple models, like:

```bash
$ rails generate allinson_flex:works Image Book GenericWork
```

Accept the overwrite when requested:

```
Overwrite /app/samvera/hyrax-webapp/app/views/hyrax/base/_attribute_rows.html.erb? (enter "h" for help) [Ynaqdhm]
```

You must restart rails after generating work classes.

## Contributing
See
[CONTRIBUTING.md](https://github.com/samvera-labs/allinson_flex/blob/master/CONTRIBUTING.md)
for contributing guidelines.

We encourage everyone to help improve this project.  Bug reports and pull requests are welcome on GitHub at https://github.com/samvera-labs/allinson_flex.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](https://contributor-covenant.org) code of conduct.

All Contributors should have signed the Hydra Contributor License Agreement (CLA)

## Questions
Questions can be sent to support@notch8.com. Please make sure to include "AllinsonFlex" in the subject line of your email.

## License
The gem is available as open source under the terms of the [Apache 2.0 License](https://opensource.org/licenses/Apache-2.0).

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags).

## Dedication

From the beginning of the Samvera community to her sudden passing in 2020, Julie Allinson (@geekscruff)
was a strong presence in the Samvera community. Always ready to lend a hand or to share knowledge, she
embodied so much of what makes this community work. This effort, the last big project she was involved
in, was the culmination not just of her time as a developer but the combination of her work as a metadata
specialist. It was the evolution of dog biscuits, her work in the m3 group and several other projects she
had lead or been involved in. She was an incredible bright star and we name this gem in remembrance of
her.

## Acknowledgments

* Indiana University - This work was initially commissioned for the ESSI project. We will always be grateful for their patience and the opportunity to take a hard swing at such a big set of challenges.
