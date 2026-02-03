
Change.new do |v|
  # The label used in the URLs of all the resource versions created by this change, usually a date.
  v.label "2024-05-15"
  # Changelog style description of the change
  v.comment "Initial release of Perseus Scheme"
  # An ID used to refer to this change in resource descriptions
  # A bit unsure about whether this is worth having, logic is that the date gives no context
  # and may change before release, and the description is long and will probably change.
  # If two Schemes try to use the same ID, they'll get an error.
  v.id "PERSEUS-INITIAL"
end

Change.new do |v|
  v.label "2024-06-10"
  v.comment "Added REST API endpoint specifications for address verification"
  v.id "ADDR-VERIFICATION-2024"
end

Change.new do |v|
  v.label "2024-07-01"
  v.comment "Updated access control policies and role-based authorization rules for Auditors"
  v.id "AUDITORS-ACCESS"
end

Change.new do |v|
  # We're not using branching, we're just going to say that some changes aren't in all environments.
  v.only_in_environments :sandbox, :preprod
  v.label "2024-08-15"
  v.comment "Updated Policies for new industry compliance requirements"
  v.id "INDUSTRY-COMPLIANCE-2024"
end

Change.new do |v|
  # This will throw and error because :proprod is not in the list.
  # This restriction is because changes are written as deltas from the previous version.
  # So if you add a change in the middle of the sequence, it would alter versions after it.
  v.only_in_environments :production
  v.label "2024-09-20"
  v.comment "Enhanced logging and monitoring for transaction tracking"
  v.id "TRANSACTION-LOGGING-2024"
end

