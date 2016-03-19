require "singleton"
require "unitwise"

module KitchenMeasures
  class Measure
    include Comparable

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

    def self.from_unitwise(unitwise)
      new(unitwise.value, unitwise.unit)
    end

    def self.without_unit(quantity)
      new(quantity, Unitless.instance)
    end

    def to_s
      [quantity, unit].join(" ").strip
    end

    def <=>(other)
      if unitless?
        quantity <=> other.quantity
      else
        to_unitwise <=> other.to_unitwise
      end
    end

    def unitless?
      unit == Unitless.instance
    end

    def *(value)
      if unitless?
        self.class.without_unit(quantity * value)
      else
        self.class.from_unitwise(to_unitwise * value)
      end
    end

    def /(value)
      if unitless?
        self.class.without_unit(quantity / value)
      else
        self.class.from_unitwise(to_unitwise / value)
      end
    end

    def comparable_with?(other)
      if [self, other].all?(&:unitless?)
        true
      elsif [self, other].any?(&:unitless?)
        false
      elsif to_unitwise <=> other.to_unitwise
        true
      else
        false
      end
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
