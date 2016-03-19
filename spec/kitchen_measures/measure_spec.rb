require "spec_helper"

RSpec.describe KitchenMeasures::Measure do
  describe "#to_s" do
    specify do
      unit = double(:unit, to_s: "g")
      measure = described_class.with_unit(1, unit)

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

  # describe "calculations" do
  #   specify do
  #     measure = described_class.with_unit(1, "kg")
  #
  #     result = measure * 2
  #
  #     expect(result).to eq(described_class.with_unit(2, "kg"))
  #   end
  #
  #   specify do
  #     measure = described_class.with_unit(2, "kg")
  #
  #     result = measure / 2
  #
  #     expect(result).to eq(described_class.with_unit(1, "kg"))
  #   end
  # end

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
end