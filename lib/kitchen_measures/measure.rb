require "singleton"
require "unitwise"

module KitchenMeasures
  class Measure
    class Unitless
      include Singleton

      def to_s
        ""
      end
    end

    def initialize(quantity, unit)
      @quantity = quantity
      @unit = unit or raise ArgumentError("Missing unit")
    end

    def self.with_unit(quantity, unit)
      new(quantity, unit)
    end

    def self.without_unit(quantity)
      new(quantity, Unitless.instance)
    end

    def to_s
      [quantity, unit].join(" ").strip
    end

    def ==(other)
      if unitless?
        quantity == other.quantity && unit == other.unit
      else
        to_unitwise == other.to_unitwise
      end
    end

    def <=>(other)
      to_unitwise <=> other.to_unitwise
    end

    def unitless?
      unit == Unitless.instance
    end

    protected

    attr_reader :quantity, :unit

    def to_unitwise
      if unit == Unitless.instance
        raise "Cannot convert unitless measure to Unitwise"
      end

      Unitwise(quantity, unit)
    end
  end
end
