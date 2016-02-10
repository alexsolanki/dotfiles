# Fact to define the rack topology from the fqdn
#
# Visit the wiki page below under rack layout to see what rack a
# node should be placed in
# http://wiki.rubiconproject.com/display/techops/MapR+DataNode+Verification+Process

Facter.add("mapr_racktopo") do
  confine :fanrole => %w{cld jtr com}
  setcode do
    retval = ""
    case Facter.value(:fanrole)
      when "cld"
        retval = "/cldb"
      when "jtr"
        case Facter.value(:fanhostgroupalphaonly)
          when "fmap-jtr"
            retval = "/jobtracker"
          else
            retval = "/resourcemanager"
          end
      when "com"
        case Facter.value(:fandatacenter)
          when "las2"
            case Facter.value(:fanhostgroupalphaonly)
              when "fmap-com"
                case Facter.value(:fanhostsequence).to_i
                  when 1000..1029
                    rack_number = 5607
                  when 1030..1059
                    rack_number = 5606
                  when 1060..1089
                    rack_number = 5605
                  when 1090..1119
                    rack_number = 5604
                  when 1120..1149
                    rack_number = 5615
                  when 1150..1179
                    rack_number = 5616
                  when 1180..1209
                    rack_number = 5617
                  when 1210..1239
                    rack_number = 5618
                  end
                if rack_number.to_s.length > 0
                  # We know what rack if it matched a case and was assigned
                  retval = "/data/rack" + rack_number.to_s
                else
                  # When the fanhostsequence does not match a range
                  retval = "undefined"
                end
              when "fmas-com"
                case Facter.value(:fanhostsequence).to_i + 20000
                  when 20000..20026
                    rack_number = 5622
                  when 20027..20053
                    rack_number = 5621
                  when 20054..20080
                    rack_number = 5620
                  end
                if rack_number.to_s.length > 0
                  # We know what rack if it matched a case and was assigned
                  retval = "/data/rack" + rack_number.to_s
                else
                  # When the fanhostsequence does not match a range
                  retval = "undefined"
                end
              when "fbmq-com"
                case Facter.value(:fanhostsequence).to_i + 20000
                  when 20000..20006
                    rack_number = 201
                  when 20007..20013
                    rack_number = 202
                  when 20014..20019
                    rack_number = 203
                  end
                if rack_number.to_s.length > 0
                  # We know what rack if it matched a case and was assigned
                  retval = "/data/rack0" + rack_number.to_s
                else
                  # When the fanhostsequence does not match a range
                  retval = "undefined"
                end
              else
                # When the fanhostgroupalpha doesn't match a case
                retval = "undefined"
              end
          when "lab1"
            case Facter.value(:fanhostgroupalphaonly)
              when "fmad-com"
                  retval = "/data/rack9000"
              else
                  retval = "undefined"
              end
          else
            # When the datacenter doesn't match a case
            retval = "undefined"
          end
      else
        retval = "undefined"
      end
    retval
  end
end
