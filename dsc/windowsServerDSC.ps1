Configuration windowsFirewallOff {
    node ("localhost") {
       Registry NoFirewallDomain {
          Ensure    = "Present"
          Key       = "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile"
          ValueName = "EnableFirewall"
          ValueType = "Dword"
          ValueData = [int]0
        }
       Registry NoFirewallPrivate {
          Ensure    = "Present"
          Key       = "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile"
          ValueName = "EnableFirewall"
          ValueType = "Dword"
          ValueData = [int]0
        }
       Registry NoFirewallPublic {
          Ensure    = "Present"
          Key       = "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile"
          ValueName = "EnableFirewall"
          ValueType = "Dword"
          ValueData = [int]0
        }
    }
} 