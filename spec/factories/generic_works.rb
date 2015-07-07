FactoryGirl.define do
  factory :work, aliases: [:generic_work, :private_generic_work], class: GenericWork do
    transient do
      user { FactoryGirl.create(:user) }
      embargo_date { Date.tomorrow.to_s }
    end

    title ["Test title"]
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE

    before(:create) do |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
    end


    factory :public_generic_work do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end

    factory :work_with_one_file do
      after(:create) { |work, evaluator| Hydra::Works::AddGenericFileToGenericWork.call(work, FactoryGirl.create(:generic_file, user: evaluator.user, title:['A Contained Generic File'], filename:['filename.pdf'])) }
    end

    factory :work_with_files do
      after(:create) { |work, evaluator| 2.times { Hydra::Works::AddGenericFileToGenericWork.call(work, FactoryGirl.create(:generic_file, user: evaluator.user)) } }
    end

    factory :embargoed_work do
      after(:build) { |work, evaluator| work.apply_embargo(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
    end

    factory :embargoed_work_with_files do
      after(:build) { |work, evaluator| work.apply_embargo(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
      after(:create) { |work, evaluator| 2.times { Hydra::Works::AddGenericFileToGenericWork.call(work, FactoryGirl.create(:generic_file, user: evaluator.user)) } }
    end

    factory :leased_work do
      after(:build) { |work, evaluator| work.apply_lease(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE) }
    end

    factory :leased_work_with_files do
      after(:build) { |work, evaluator| work.apply_lease(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE) }
      after(:create) { |work, evaluator| 2.times { Hydra::Works::AddGenericFileToGenericWork.call(work, FactoryGirl.create(:generic_file, user: evaluator.user)) } }
    end
  end
end