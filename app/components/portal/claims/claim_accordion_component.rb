module Portal
  module Claims
    # with inheritance this component is using shared accordion template
    class ClaimAccordionComponent < Shared::UI::AccordionComponent
      def initialize(id:, title:, stage:, icon_name: "", counter: nil)
        @id = id
        @title = title
        @icon_name = icon_name
        @stage = stage
        @counter = counter
      end

      def classes
        if completed_stage?
          "accordion__stepper accordion__stepper__complete"
        elsif current_stage?
          "accordion__stepper accordion__stepper__active"
        else
          "accordion__stepper accordion__stepper__next"
        end
      end

      def pill_counter_class
        if completed_stage?
          "accordion__stepper--pill accordion__stepper--pill__complete"
        elsif current_stage?
          "accordion__stepper--pill accordion__stepper--pill__active"
        else
          "accordion__stepper--pill accordion__stepper--pill__next"
        end
      end

      def is_disabled
        "disabled" if future_stage?
      end

      def active
        @stage.current?
      end

      private

      def current_stage?
        @stage.current?
      end

      def completed_stage?
        @stage.completed?
      end

      def future_stage?
        @stage.future?
      end
    end
  end
end
