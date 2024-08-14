FactoryBot.define do
  factory :bright_policy do
    transient do
      effective_date { 10.days.from_now }
    end

    ratings { [build(:rating, total_premium: (365 * 10 + 25).to_i)] }
    property
    coverage { build(:coverage, effective_date: effective_date) }
    payment_schedule { "full" }
    payment_type { "escrow" }
    product do
      desired_product = build(:product, :kin_florida_ho3)
      Product.cached(desired_product) || desired_product
    end

    after(:build) do |bright_policy|
      0.upto(bright_policy.term.to_i) do |number|
        term_interval = Term::DEFAULT_INTERVAL * number

        bright_policy.terms.build(
          bright_policy: bright_policy,
          number: number,
          effective_date: bright_policy.effective_date + term_interval,
          end_date: bright_policy.effective_date + term_interval + Term::DEFAULT_INTERVAL
        )
      end
    end

    # The following trait is used to fully randomize data for a policy, product, property, rating, and coverage.
    # It does however add several seconds to a test setup time, so use sparingly.
    trait :robust do
      full_policy_number { Faker::Alphanumeric.alpha(number: 8) }
      property { build(:property, :robust) }
      coverage { build(:coverage, :robust) }
      frozen_rating { build(:rating, :robust) }
      product { build(:product, :robust) }

      after(:build) do |bright_policy, _|
        # Additional Insureds
        bright_policy.additional_insureds.build(contact: create(:person), contact_type: "Person")
        bright_policy.additional_insureds.build(contact: create(:person), contact_type: "Person")
        # Additional Interests
        bright_policy.additional_interests.build(contact: create(:person), contact_type: "Person", description: Faker::Movie.title)
        bright_policy.additional_interests.build(contact: create(:person), contact_type: "Person", description: Faker::Movie.title)
        # Applicant
        bright_policy.applicants.build(contact: create(:person), contact_type: "Person", co_applicant: false)
        # CoApplicant
        bright_policy.applicants.build(contact: create(:person), contact_type: "Person", co_applicant: true)
        # First Mortgagee
        bright_policy.mortgagees.build(
          contact: build(:bright_mortgagee),
          position: 0,
          loan_number: 1,
          mortgagee_clause: Faker::Company.name
        )
        # Second Mortgagee
        bright_policy.mortgagees.build(
          contact: build(:bright_mortgagee),
          position: 1,
          loan_number: 1,
          mortgagee_clause: Faker::Company.name
        )
      end
    end

    trait :reciprocal do
      product { build(:product, :kin_florida_ho3) }
    end

    # By State Alphabetically
    trait :kin_alabama_hd3 do
      ratings { [build(:rating, :al_hd3)] }
      product { build(:product, :kin_alabama_hd3) }
    end

    trait :kin_arizona_hd3 do
      ratings { [build(:rating, :az_hd3)] }
      product { build(:product, :kin_arizona_hd3) }
    end

    trait :kin_arizona_mh3 do
      ratings { [build(:rating, :az_mh3)] }
      product { build(:product, :kin_arizona_mh3) }
    end

    trait :kin_california_ho3 do
      product { build(:product, :kin_california_ho3) }
    end

    trait :kin_florida_dp3 do
      ratings { [build(:rating)] }
      product { build(:product, :kin_florida_dp3) }
    end

    trait :kin_florida_ho3 do
      ratings { [build(:rating, :fl_ho3)] }
      product { build(:product, :kin_florida_ho3) }
    end

    trait :kin_florida_ho3_20240201 do
      ratings { [build(:rating, :fl_ho3)] }
      product { build(:product, :kin_florida_ho3_20240201) }
    end

    trait :kin_florida_ho6 do
      ratings { [build(:rating, :kin_florida_ho6)] }
      product { build(:product, :kin_florida_ho6) }
    end

    trait :kin_florida_mh3 do
      ratings { [build(:rating, :fl_mobile_home, total_premium: (365 * 10 + 25).to_i)] }
      product { build(:product, :kin_florida_mh3) }
    end

    trait :kin_georgia_hd3 do
      ratings { [build(:rating, :ga_hd3)] }
      product { build(:product, :kin_georgia_hd3) }
    end

    trait :kin_louisiana_dp3 do
      ratings { [build(:rating, :la_dp3)] }
      product { build(:product, :kin_louisiana_dp3) }
    end

    trait :kin_louisiana_ho3 do
      ratings { [build(:rating, :la_ho3)] }
      product { build(:product, :kin_louisiana_ho3) }
    end

    trait :kin_louisiana_mh3 do
      product { build(:product, :kin_louisiana_mh3) }
    end

    trait :kin_michigan_hd3 do
      ratings { [build(:rating, :mi_hd3)] }
      product { build(:product, :kin_michigan_hd3) }
    end

    trait :kin_mississippi_hd3 do
      ratings { [build(:rating, :ms_hd3)] }
      product { build(:product, :kin_mississippi_hd3) }
    end

    trait :kin_new_jersey_hd3 do
      ratings { [build(:rating, :nj_hd3)] }
      product { build(:product, :kin_new_jersey_hd3) }
    end

    trait :kin_south_carolina_hd3 do
      ratings { [build(:rating, :sc_hd3)] }
      product { build(:product, :kin_south_carolina_hd3) }
    end

    trait :kin_texas_hd3 do
      ratings { [build(:rating, :tx_hd3)] }
      product { build(:product, :kin_texas_hd3) }
    end

    trait :kin_texas_mh3 do
      ratings { [build(:rating, :tx_mh3)] }
      product { build(:product, :kin_texas_mh3) }
    end

    trait :kin_virginia_hd3 do
      ratings { [build(:rating, :va_hd3)] }
      product { build(:product, :kin_virginia_hd3) }
    end

    trait :kin_tennessee_hd3 do
      ratings { [build(:rating, :tn_hd3)] }
      product { build(:product, :kin_tennessee_hd3) }
    end

    trait :kin_colorado_hd3 do
      ratings { [build(:rating, :co_hd3)] }
      product { build(:product, :kin_colorado_hd3) }
    end

    trait :condo do
      product { build(:product, :kin_florida_ho6) }
    end

    trait :condo_lowrise do
      product { build(:product, :kin_fl_ho6_lowrise) }
    end

    trait :non_reciprocal do
      product { build(:product, :non_reciprocal) }
    end

    trait :with_frozen_rating do
      frozen_rating { ratings&.last }
    end

    trait :with_policy_snapshots do
      after(:create) do |bright_policy, _|
        bright_policy.effective_policy_snapshots.create(
          start_date: bright_policy.effective_date,
          end_date: bright_policy.end_date,
          data: BrightPolicySnapshotSerializer.new(bright_policy).as_json
        )
      end
    end

    trait :with_assigned_csr do
      transient do
        csr { build(:csr) }
        status { "bound" }
        crm_account_status { "assigned" }
      end

      after(:create) do |policy, evaluator|
        Crm::Account.skip_callback(:commit, :after, :notify_comms)
        crm_account = build(:crm_account, :with_person, status: evaluator.crm_account_status)
        assignment = build(:crm_assignment,
          crm_account: crm_account,
          assigned_to: evaluator.csr)
        assignment.save!
        Crm::Account.set_callback(:commit, :after, :notify_comms)
        policy.applicants.create!(contact: crm_account.people.first,
          contact_type: "Person",
          co_applicant: false)
      end
    end

    trait :with_primary_insured do
      after(:build) do |bright_policy, _|
        person = create(:person)
        bright_policy.applicants.build(contact: person, contact_type: "Person", co_applicant: false)
      end
    end

    trait :with_primary_insured_and_visited_customer_portal do
      after(:build) do |bright_policy, _|
        person = create(:person)
        bright_policy.applicants.build(contact: person, contact_type: "Person", co_applicant: false)
        person.user.user_interactions.create(page_visited: "customer_portal")
      end
    end

    trait :with_opportunity_and_assignment do
      after(:build) do |bright_policy, _|
        crm_account = create(:crm_account, :with_assignment)
        person = create(:person, crm_account: crm_account)
        opportunity = create(:opportunity, primary_person: person, address: bright_policy.property.address, crm_assignment: crm_account.crm_assignment)
        bright_policy.applicants.build(contact: opportunity.primary_person, contact_type: "Person", co_applicant: false)
      end
    end

    trait :with_primary_insured_with_crm_account do
      after(:build) do |bright_policy, _|
        person = build(:person, :with_crm_account)
        bright_policy.applicants.build(contact: person, contact_type: "Person", co_applicant: false)
      end
    end

    trait :with_primary_insured_with_signed_documents do
      after(:build) do |bright_policy, _|
        person = build(:person, subscriber_agreement_signed_at: Date.current)
        bright_policy.applicants.build(contact: person, contact_type: "Person", co_applicant: false)
      end
    end

    trait :with_co_applicant do
      after(:build) do |bright_policy, _|
        person = build(:person)
        bright_policy.applicants.build(contact: person, contact_type: "Person", co_applicant: true)
      end
    end

    trait :with_persisted_user do
      after(:create) do |bright_policy, _|
        bright_policy.applicants.create(contact: create(:person, user: create(:user)), co_applicant: false)
      end
    end

    trait :with_primary_and_co_applicant do
      after(:build) do |bright_policy, _|
        person = build(:person)
        bright_policy.applicants.build(contact: person, contact_type: "Person", co_applicant: true)
        co_app = build(:person)
        bright_policy.applicants.build(contact: co_app, contact_type: "Person", co_applicant: false)
      end
    end

    trait :with_primary_and_co_applicant_with_signatures do
      after(:build) do |bright_policy, _|
        person = build(:person, subscriber_agreement_signed_at: Date.current)
        bright_policy.applicants.build(contact: person, contact_type: "Person", co_applicant: true)
        co_app = build(:person, subscriber_agreement_signed_at: Date.current)
        bright_policy.applicants.build(contact: co_app, contact_type: "Person", co_applicant: false)
      end
    end

    trait :with_additional_insured do
      after(:build) do |bright_policy, _|
        person = build(:person)
        bright_policy.additional_insureds.build(contact: person, contact_type: "Person")
      end
    end

    trait :with_additional_interest do
      after(:build) do |bright_policy, _|
        person = build(:person)
        bright_policy.additional_interests.build(contact: person, contact_type: "Person")
      end
    end

    trait :with_mortgagee do
      after(:build) do |bright_policy, _|
        bright_policy.mortgagees.build(
          contact: build(:bright_mortgagee),
          position: 0,
          loan_number: 1,
          mortgagee_clause: Faker::Company.name
        )
      end
    end

    trait :with_customer_input do
      association :customer_input_response
    end

    trait :with_mortgagee_payor do
      payment_type { :escrow }
      with_mortgagee
      after(:build) do |bright_policy, _|
        bright_policy.mortgagees.first.update(payor: true)
      end
    end

    trait :with_payor_contact do
      payment_type { :card }
      with_primary_insured
      after(:create) do |bright_policy, _|
        bright_policy.policy_contacts.first.update(payor: true)
      end
    end

    trait :with_prior_carrier do
      after(:build) do |bright_policy, _|
        bright_policy.build_prior_carrier(contact: build(:insurance_carrier))
      end
    end

    trait :with_kin_carrier do
      ready_to_bind
      after(:build) do |bright_policy, _|
        bright_policy.product.insurance_carrier = build(:insurance_carrier, :kin)
      end
    end

    trait :with_falls_lake_carrier do
      ready_to_bind
      after(:build) do |bright_policy, _|
        bright_policy.product.insurance_carrier = build(:insurance_carrier, :falls_lake)
      end
    end

    trait :with_windstorm_mitigation do
      after(:build) do |bright_policy, _|
        bright_policy.property.fbc_wind_speed = "100"
        bright_policy.property.inspection_company = Faker::Company.name
        bright_policy.property.inspection_date = Faker::Date.backward(days: 180)
        bright_policy.property.opening_protection = "basic"
        bright_policy.property.roof_deck = "reinforced_concrete_roof_deck"
        bright_policy.property.secondary_water_resistance = "yes"
        bright_policy.property.terrain = "c"
        bright_policy.property.wind_borne_debris_region = "yes"
      end
    end

    trait :with_required_data_points_fl_ho3 do
      after(:build) do |bright_policy, _|
        bright_policy.property.fbc_wind_speed = "100"
        bright_policy.property.protection_class = "3"
        bright_policy.property.flood_zone = "X"
        bright_policy.property.bceg = "4"
        bright_policy.property.terrain = "b"
        bright_policy.property.wind_borne_debris_region = "no"
      end
    end

    trait :underwriting_failed do
      after(:build) do |bright_policy, _|
        bright_policy.underwriting_decisions.build(result: "failed")
      end
    end

    trait :underwriting_passed do
      after(:build) do |bright_policy, _|
        bright_policy.underwriting_decisions.build(result: "passed")
      end
    end

    trait :ready_to_bind do
      aggregate_root_id { SecureRandom.uuid }
      after(:build) do |bright_policy, _|
        bright_policy.applicants.build(contact: build(:person, user: build(:user, email: Faker::Internet.unique.email)), contact_type: "Person", co_applicant: false, payor: true)
        bright_policy.coverage ||= build(:coverage)
        bright_policy.property.assign_attributes(
          replacement_cost: 100,
          acreage: 0.5,
          months_occupied: 12,
          times_rented: 0,
          pool: false,
          wood_burning_stove_or_space_heater: "none",
          year_built: 1.year.ago.year
        )

        bright_policy.underwriting_decisions.build(result: "passed")
        # alternately, we may want to actually run the lifecycle for the policy though this takes hella long
        # BrightLifecycle::Service.lifecycle_for_policy(bright_policy).decide!
      end
    end

    trait :quote do
      status { :quote }
    end

    trait :bound do
      status { :bound }

      with_policy_snapshots
      with_frozen_rating

      after(:build) do |policy|
        policy.inspection_metadata << build(:inspection_metadata, chargeable: true, bright_policy: policy)
        policy.policy_events << build(
          :policy_event,
          bright_policy: policy
        )
      end
    end

    trait :in_force do
      status { :in_force }
      aggregate_root_id { SecureRandom.uuid }
      with_policy_snapshots
      with_frozen_rating

      after(:build) do |policy|
        policy.policy_events << build(
          :policy_event,
          bright_policy: policy
        )
      end
    end

    trait :with_metadata_chargeable_false do
      after(:build) do |policy|
        policy.inspection_metadata << build(:inspection_metadata, chargeable: false, bright_policy: policy)
      end
    end

    trait :cancelled do
      status { :cancelled }
    end

    trait :expired do
      status { :expired }
      with_policy_snapshots
    end

    trait :multi_pay do
      payment_schedule { :quarterly }
    end

    trait :non_renewed do
      status { :non_renewed }
      with_policy_snapshots
    end

    trait :do_not_renew do
      renewal_status { "do_not_renew" }
      after(:build) do |policy|
        policy.policy_events << build(
          :policy_event,
          :non_renewal,
          bright_policy: policy,
          event_reasons: [
            EventReason.find_or_create_by(
              category: :administrative,
              display_reason: "Property type is not eligible for the written policy form",
              insurance_reason_code: "property_type_not_eligible"
            )
          ]
        )
      end
    end

    trait :with_payment_required_post_bind do
      with_payor_contact
      after(:build) do |bright_policy|
        create(:blocker, :payment_required_post_bind, bright_policy: bright_policy)
      end
    end

    trait :with_quote_packages do
      after(:create) do |bright_policy|
        bright_policy.custom_quotes << create(:custom_quote, :lower, bright_policy: bright_policy)
        bright_policy.custom_quotes << create(:custom_quote, :middle, bright_policy: bright_policy)
        bright_policy.custom_quotes << create(:custom_quote, :upper, bright_policy: bright_policy)
      end
    end

    trait :payment_type_card do
      payment_type { "card" }
    end

    trait :bookroll_lead do
      bookroll_lead { build(:bookroll_lead) }
    end
  end
end
