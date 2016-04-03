require "spec_helper"

RSpec.describe KitchenMeasures::Measure do
  describe "initialization" do
    it "raises an arguemnt error if the unit is nil" do
      expect { described_class.with_unit(1, nil) }.to raise_error ArgumentError
    end

    it "raises an arguemnt error if the unit is blank" do
      expect { described_class.with_unit(1, "") }.to raise_error ArgumentError
    end
  end
  describe "#to_s" do
    specify do
      measure = described_class.with_unit(1, "g")

      result = measure.to_s

      expect(result).to eq("1 g")
    end

    specify do
      measure = described_class.without_unit(1)

      result = measure.to_s

      expect(result).to eq("1")
    end
  end

  describe "#==" do
    specify do
      measure_1 = described_class.with_unit(1, "kg")
      measure_2 = described_class.with_unit(2, "kg")

      result = measure_1 == measure_2

      expect(result).to be(false)
    end

    specify do
      measure_1 = described_class.with_unit(2, "kg")
      measure_2 = described_class.with_unit(2, "kg")

      result = measure_1 == measure_2

      expect(result).to be(true)
    end

    specify do
      measure_1 = described_class.with_unit(2, "kg")
      measure_2 = described_class.with_unit(2000, "g")

      result = measure_1 == measure_2

      expect(result).to be(true)
    end

    specify do
      measure_1 = described_class.without_unit(2)
      measure_2 = described_class.without_unit(2)

      result = measure_1 == measure_2

      expect(result).to be(true)
    end
  end

  describe "calculations" do
    specify do
      measure = described_class.with_unit(1, "kg")

      result = measure * 2

      expect(result).to eq(described_class.with_unit(2, "kg"))
    end

    specify do
      measure = described_class.without_unit(1)

      result = measure * 2

      expect(result).to eq(described_class.without_unit(2))
    end

    specify do
      measure = described_class.with_unit(2, "kg")

      result = measure / 2

      expect(result).to eq(described_class.with_unit(1, "kg"))
    end
  end

  describe "ordering" do
    specify do
      measures = [
        described_class.with_unit(500, "g"),
        described_class.with_unit(1, "kg"),
        described_class.with_unit(1, "g")
      ]

      result = measures.sort.map(&:to_s)

      expect(result).to eq(["1 g", "500 g", "1 kg"])
    end
  end

  describe "#unitless?" do
    it "returns true for unitless measures" do
      measure = described_class.without_unit(3)

      result = measure.unitless?

      expect(result).to be(true)
    end

    it "returns false for measures with a unit" do
      measure = described_class.with_unit(3, "g")

      result = measure.unitless?

      expect(result).to be(false)
    end
  end

  describe "comparable_with?" do
    context "with units" do
      it "returns true if two objects are comparable" do
        measure = described_class.with_unit(1, "g")
        other_measure = described_class.with_unit(1, "kg")

        result = measure.comparable_with?(other_measure)

        expect(result).to be(true)
      end

      it "returns false if two objects are not comparable" do
        measure = described_class.with_unit(1, "g")
        other_measure = described_class.with_unit(1, "ml")

        result = measure.comparable_with?(other_measure)

        expect(result).to be(false)
      end
    end

    context "without units" do
      it "returns true if two objects are comparable" do
        measure = described_class.without_unit(1)
        other_measure = described_class.without_unit(1)

        result = measure.comparable_with?(other_measure)

        expect(result).to be(true)
      end

      it "returns false if two objects are not comparable" do
        measure = described_class.without_unit(1)
        other_measure = described_class.with_unit(1, "ml")

        result = measure.comparable_with?(other_measure)

        expect(result).to be(false)
      end
    end
  end

  describe "#weight?" do
    specify do
      measure = described_class.with_unit(3, "kg")

      result = measure.weight?

      expect(result).to be(true)
    end

    specify do
      measure = described_class.with_unit(3, "l")

      result = measure.weight?

      expect(result).to be(false)
    end

    specify do
      measure = described_class.without_unit(3)

      result = measure.weight?

      expect(result).to be(false)
    end
  end

  describe "#volume?" do
    specify do
      measure = described_class.with_unit(3, "l")

      result = measure.volume?

      expect(result).to be(true)
    end

    specify do
      measure = described_class.with_unit(3, "kg")

      result = measure.volume?

      expect(result).to be(false)
    end
  end

  describe "#to_db_attrs" do
    specify do
      measure = described_class.with_unit(3, "kg")

      result = measure.to_db_attrs

      expect(result).to eq(quantity: 3, unit: "kg")
    end

    specify do
      measure = described_class.without_unit(3)

      result = measure.to_db_attrs

      expect(result).to eq(quantity: 3, unit: nil)
    end

    specify do
      measure = described_class.with_unit(1, "kilogram")

      result = measure.to_db_attrs

      expect(result).to include(unit: "kg")
    end

    specify do
      measure = described_class.with_unit(1, "oz fl")

      result = measure.to_db_attrs

      expect(result).to include(unit: "oz fl")
    end
  end

  describe ".from_db_attrs" do
    specify do
      result = described_class.from_db_attrs(3, "kg")

      expect(result).to eq(described_class.with_unit(3, "kg"))
    end

    specify do
      result = described_class.from_db_attrs(3, nil)

      expect(result).to eq(described_class.without_unit(3))
    end
  end
end
