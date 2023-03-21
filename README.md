<div align="center">
  <img alt="gem logo" src="/docs/lego.png">
</div>

## Dvla Dataverse Helper
##### _Integrate Microsoft Dataverse Web API to your Ruby project_

[![Ruby](https://badgen.net/badge/icon/ruby?icon=ruby&label)](https://https://ruby-lang.org/)
![Tests](https://github.com/dvla/dataverse-helper/actions/workflows/run_unit_tests.yml/badge.svg)
![Last Deployment](https://github.com/dvla/dataverse-helper/actions/workflows/gem_publish.yml/badge.svg)

Thank you for using DVLA Dataverse Helper gem. This gem helps you integrate with Microsoft Dynamics using Microsoft Dataverse Web API. You can create, retrieve, delete or update a record without worrying about authentications as it's automatically managed behind the scenes.


| 🏁  Installation & Getting statrted |
| ----------------------------------------- |


Install the gem and add to the application's Gemfile by executing:

    $ bundle add dvla-dataverse-helper

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install dvla-dataverse-helper

You can set up a template for your configurations by executing:

    $ dataverse

which will create a new yml file inside `config` folder called dataverse.yml. You will need to update the configurations before using the gem.


| 👔 Usage and examples |
| ----------------------------------------- |

Its recommended to have a constant for your Helper model:
```ruby
Dataverse = Dvla::Dataverse::Helper
```

The Dataverse helper makes it easy to create, update, retrieve and delete a record. The authentication happens automatically only if it's needed. For example, if the token is expired the Dataverse helper will set up a new token before making a request. To create a record:

```ruby
Dataverse
    .create_record('incidents', record)
    .body
```


| 🛠 Development |
| ----------------------------------------- |


After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

| 📃 License |
| ----------------------------------------- |

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).



