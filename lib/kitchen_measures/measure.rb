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

    def self.with_unit(quantity, unit)
      raise ArgumentError, "Missing unit" if unit.nil?
      raise ArgumentError, "Blank unit" if unit.strip == ""
      new(quantity, unit)
    end

    def self.from_unitwise(unitwise)
      new(unitwise.value, unitwise.unit)
    end

    def self.without_unit(quantity)
      new(quantity, Unitless.instance)
    end

    def self.from_db_attrs(quantity, db_unit)
      if db_unit
        with_unit(quantity, db_unit)
      else
        without_unit(quantity)
      end
    end

    def initialize(quantity, unit)
      @quantity = quantity
      @unit = unit
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

    def weight?
      return false if unitless?
      unitwise_property == "mass"
    end

    def volume?
      return false if unitless?
      unitwise_property == "volume"
    end

    def to_db_attrs
      {
        quantity: quantity,
        unit: db_unit
      }
    end

    protected

    attr_reader :quantity, :unit

    def unit_normalized
      term = to_unitwise.unit.terms.first
      [term.prefix.to_s, term.atom.symbol].join
    end

    def to_unitwise
      if unitless?
        raise "Cannot convert unitless measure to Unitwise"
      end

      Unitwise(quantity, unit)
    end

    private

    def to_s_normalized
      [quantity, unit_normalized].join(" ").strip
    end

    def unitwise_property
      terms = to_unitwise.terms
      raise "Multiple terms" if terms.size > 1
      terms.first.atom.property
    end

    def db_unit
      if unitless?
        nil
      else
        unit_normalized
      end
    end
  end
end
