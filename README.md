# KitchenMeasures

This gem provides a simple [value object][] for dealing with measures used in
cooking and baking. Behind the scenes it uses [unitwise]. The main difference in
behaviour is support for unitless measures which are often found in recipes, such
as "2 eggs" or "1 large carrot".

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kitchen_measures'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kitchen_measures

## Usage

```ruby
flour_measure = KitchenMeasures::Measure.with_unit(500, "g")
sugar_measure = KitchenMeasures::Measure.with_unit(2, "oz")
water_measure = KitchenMeasures::Measure.with_unit(1, "l")
eggs_measure = KitchenMeasures::Measure.without_unit(6)

flour_measure.to_s #=> 1000 g
sugar_measure.to_s #=> 2 oz
water_measure.to_s #=> 2 l
eggs_measure.to_s #=> 12

flour_measure.comparable_with?(sugar_measure) #=> true
flour_measure.comparable_with?(water_measure) #=> false
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andyw8/kitchen_measures.

[value object]: https://en.wikipedia.org/wiki/Value_object
[unitwise]: https://github.com/joshwlewis/unitwise
