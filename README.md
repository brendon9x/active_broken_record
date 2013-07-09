# ActiveBrokenRecord

For when you wished you were still using Hibernate, or your hopes were dashed when the identity map was pulled from ActiveRecord.  Or simply, you want to know if all of those SQL calls flashing by in your console are really necessary, and if not, where they can fixed.

## Installation

Add this line to your application's Gemfile:

    gem 'activebrokenrecord'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activebrokenrecord

## Usage

Usage is automatic so only require when you want this.  Duplicate SQL queries are logged with backtraces.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
